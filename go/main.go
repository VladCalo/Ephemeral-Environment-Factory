package main

import (
	"bytes"
	"fmt"
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
	repoURL := strings.TrimSpace(out.String())
	if repoURL == "" {
		return "", fmt.Errorf("git remote origin URL is empty")
	}
	return repoURL, nil
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

	appName := os.Args[1]
	chartName := os.Args[2]
	namespace := os.Args[3]

	// Basic validation
	if appName == "" || chartName == "" || namespace == "" {
		log.Fatalf("Error: appName, chartName, and namespace cannot be empty")
	}

	repoURL, err := getGitRepoURL()
	if err != nil {
		log.Fatalf("Error getting git repository URL: %v", err)
	}
	repoURL = normalizeRepoURL(repoURL)

	// Make chart path relative to the git root or current working dir
	chartPath := filepath.Join("helm", chartName)

	// Check if chart directory exists
	if _, err := os.Stat(chartPath); os.IsNotExist(err) {
		log.Fatalf("Error: chart directory does not exist: %s", chartPath)
	}

	// Resolve absolute paths for template + output
	wd, err := os.Getwd()
	if err != nil {
		log.Fatalf("Error getting working directory: %v", err)
	}

	// Template path should be relative to the go directory
	tmplPath := filepath.Join(wd, "go", "templates", "app.yaml.tmpl")
	outputDir := filepath.Join(wd, "argocd")
	outputPath := filepath.Join(outputDir, appName+".yaml")

	// Check if template exists
	if _, err := os.Stat(tmplPath); os.IsNotExist(err) {
		log.Fatalf("Error: template file not found: %s", tmplPath)
	}

	// Create output directory if it doesn't exist
	if err := os.MkdirAll(outputDir, 0755); err != nil {
		log.Fatalf("Error creating output directory: %v", err)
	}

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
