{% from "backup_restic_minio/map.jinja" import config with context %}

docker-containers:
  lookup:
    {%- for app in config.targets %}
    {{ app.name }}:
      image: {{ app.image }}
      {%- if app.command is defined and app.command|length %}cmd: {{ app.command }}{%- endif %}
      {%- if app.docker_args is defined and app.docker_args|length %}
      runoptions: {{ app.docker_args }}
      {%- endif %}
    {%- endfor %}