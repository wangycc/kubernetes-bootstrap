#!/usr/bin/python

import subprocess
import argparse

try:
    import jinja2
except Exception as e:
    subprocess.call('sudo pip install Jinja2',shell=True)

from jinja2 import Template

def render_statefulset(name,serv_path,tag,jinja2_file='statefulset.yml.jinja2'):
    
    with open(jinja2_file) as file:
        template_file = Template(file.read())

    return template_file.render(name=name,
				serv_path=serv_path,
				tag=tag)


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--serv', type=str, help='servic name',required=True)
    parser.add_argument('--name', type=str, help='statefulset name',required=True)
    parser.add_argument('--tag', type=str, help='docker image tag',default='latest')
    args = parser.parse_args()
    serv = args.serv
    name = args.name
    tag = args.tag
    ret = render_statefulset(name,serv,tag)
    with open('%s-statefulset.yml' %(name),'w+') as f:
	f.write(ret)
    print("%s-statefulset.yml generation completed" %(name))

   

main()
