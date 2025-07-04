package main

import (
	"bytes"
	"log"
	"os"
	"os/exec"
	"path/filepath"
	"strings"
	"text/template"
)

type AppData struct {
	AppName   string
	RepoURL   string
	ChartPath string
	Revision  string
	Namespace string
}

func getGitRepoURL() (string, error) {
	cmd := exec.Command("git", "config", "--get", "remote.origin.url")
	var out bytes.Buffer
	cmd.Stdout = &out
	err := cmd.Run()
	if err != nil {
		return "", err
	}
	return strings.TrimSpace(out.String()), nil
}

func normalizeRepoURL(repoURL string) string {
	if strings.HasPrefix(repoURL, "git@github.com:") {
		repoPath := strings.TrimPrefix(repoURL, "git@github.com:")
		return "https://github.com/" + strings.TrimSuffix(repoPath, ".git") + ".git"
	}
	return repoURL
}

func main() {
	if len(os.Args) != 4 {
		log.Fatalf("Usage: %s <appName> <chartName> <namespace>", os.Args[0])
	}

	repoURL, err := getGitRepoURL()
	if err != nil {
		log.Fatalf("Error getting git repository URL: %v", err)
	}
	repoURL = normalizeRepoURL(repoURL)

	appName := os.Args[1]
	chartName := os.Args[2]
	namespace := os.Args[3]

	// Make chart path relative to the git root or current working dir
	chartPath := filepath.Join("helm", chartName)

	// Resolve absolute paths for template + output
	wd, err := os.Getwd()
	if err != nil {
		log.Fatalf("Error getting working directory: %v", err)
	}

	tmplPath := filepath.Join(wd, "templates", "app.yaml.tmpl")
	outputDir := filepath.Join(wd, "..", "argocd")
	outputPath := filepath.Join(outputDir, appName+".yaml")

	data := AppData{
		AppName:   appName,
		RepoURL:   repoURL,
		ChartPath: chartPath,
		Revision:  "HEAD",
		Namespace: namespace,
	}

	tmpl, err := template.ParseFiles(tmplPath)
	if err != nil {
		log.Fatalf("Error parsing template: %v", err)
	}

	outputFile, err := os.Create(outputPath)
	if err != nil {
		log.Fatalf("Error creating output file: %v", err)
	}
	defer outputFile.Close()

	err = tmpl.Execute(outputFile, data)
	if err != nil {
		log.Fatalf("Error rendering template: %v", err)
	}

	log.Printf("✅ Generated: %s", outputPath)
}