#!/usr/bin/env python3

import subprocess
import re
import os
from typing import Dict, List


def run_multipass_list() -> str:
    try:
        result = subprocess.run(['multipass', 'list'],
                              capture_output=True,
                              text=True,
                              check=True)
        return result.stdout
    except subprocess.CalledProcessError as e:
        print(f"Error running multipass list: {e}")
        return ""
    except FileNotFoundError:
        print("Error: multipass command not found")
        return ""


def parse_multipass_output(output: str) -> Dict[str, Dict[str, str]]:
    vms = {}
    lines = output.strip().split('\n')
    
    for line in lines[1:]:
        line = line.strip()
        if not line:
            continue
        
        match = re.match(r'^(\S+)\s+(\S+)\s+(\S+)\s+(.+)$', line)
        
        if match:
            name, state, ip, image = match.groups()
            
            if ip == '--':
                continue
            
            vms[name] = {
                'ip': ip,
                'state': state,
                'image': image.strip()
            }
    
    return vms


def categorize_vms(vms: Dict[str, Dict[str, str]]) -> Dict[str, List[str]]:
    master = []
    workers = []
    
    for name in vms.keys():
        if 'master' in name:
            master.append(name)
        elif 'worker' in name:
            workers.append(name)
    
    return {
        'master': master,
        'workers': workers
    }


def validate_vms(vms: Dict[str, Dict[str, str]]) -> tuple[bool, List[str]]:
    errors = []
    
    # Check if all VMs are running
    for name, info in vms.items():
        if info['state'] != 'Running':
            errors.append(f"{name}: not running (state: {info['state']})")
    
    # Check for duplicate IPs
    ips = [info['ip'] for info in vms.values()]
    if len(ips) != len(set(ips)):
        duplicate_ips = [ip for ip in set(ips) if ips.count(ip) > 1]
        errors.append(f"Duplicate IPs found: {duplicate_ips}")
    
    # Check if we have at least one master and one worker
    categories = categorize_vms(vms)
    if not categories['master']:
        errors.append("No master node found")
    if not categories['workers']:
        errors.append("No worker nodes found")
    
    return len(errors) == 0, errors


def update_hosts_ini(vms: Dict[str, Dict[str, str]], project_root: str = "..") -> bool:
    hosts_file = os.path.join(project_root, "ansible", "inventory", "hosts.ini")
    
    if not os.path.exists(hosts_file):
        print(f"Hosts file not found: {hosts_file}")
        return False
    
    with open(hosts_file, 'r') as f:
        content = f.read()
    
    for name, info in vms.items():
        if info['state'] == 'Running':
            pattern = rf'{re.escape(name)}\s+ansible_host=\S+'
            replacement = f'{name} ansible_host={info["ip"]}'
            content = re.sub(pattern, replacement, content)
    
    with open(hosts_file, 'w') as f:
        f.write(content)
    
    return True


def main():
    output = run_multipass_list()
    if not output:
        print("No output from multipass list command.")
        return
    
    vms = parse_multipass_output(output)
    
    # Validate VMs
    is_valid, errors = validate_vms(vms)
    
    if not is_valid:
        print("Validation errors:")
        for error in errors:
            print(f"  {error}")
        return
    
    categories = categorize_vms(vms)
    print(f"Master: {categories['master']}")
    print(f"Workers: {categories['workers']}")
    print(f"Total VMs: {len(vms)}")
    print("All VMs are running with unique IPs")
    
    # Update hosts.ini with current IPs
    if update_hosts_ini(vms):
        print("Updated ansible/inventory/hosts.ini with current IPs")
    else:
        print("Failed to update hosts.ini")


if __name__ == "__main__":
    main()
