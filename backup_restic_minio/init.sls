{% from "backup_restic_minio/map.jinja" import config with context %}
include:
  - docker

docker-image-postgres:
  cmd.run:
    - name: docker pull {{ config.postgres.image }} | grep "Postgres Image is up to date" >/dev/null 2>&1 || echo "changed=yes comment='Image updated'"
    - stateful: True
    - require:
      - service: docker-service

docker-image-mysql:
  cmd.run:
    - name: docker pull {{ config.mysql.image }} | grep "MySQL Image is up to date" >/dev/null 2>&1 || echo "changed=yes comment='Image updated'"
    - stateful: True
    - require:
      - service: docker-service

{%- for app in config.targets %}
{%- set db_config   = config.get(app.get('db_type', 'postgres')) %}
{%- set command     = app.get('command', '') %}
{%- set args        = app.get('args', '') %}
{%- set image        = app.get('image', db_config.get('image') ) %}
{%- set docker_start_command = "/usr/bin/docker run %s --name=%s %s %s %s"|format(app.run_ops, app.name, image, command, args) %}
backup_run_{{ app.name }}:
  cmd.run:
    - name: {{ docker_start_command }}
{%- endfor %}
