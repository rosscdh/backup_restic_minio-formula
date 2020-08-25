{% from "backup_restic_minio/map.jinja" import config with context %}
include:
  - docker

{%- if config.update_images %}
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
{%- endif %}

{%- for app in config.targets %}
{%- set db_config   = config.get(app.get('db_type', 'postgres')) %}
{%- set command     = app.get('command', '') %}
{%- set args        = app.get('args', []) | join(' ') %}
{%- set image       = app.get('image', db_config.get('image')) %}
{%- set run_ops     = app.get('run_ops', []) | join(' ') %}

{%- set docker_start_command = "%s run %s --name=%s %s %s %s"|format(config.docker_bin, run_ops, app.name, image, command, args) %}
backup_run_{{ app.name }}:
  cmd.run:
    - name: {{ docker_start_command }}
{%- endfor %}
