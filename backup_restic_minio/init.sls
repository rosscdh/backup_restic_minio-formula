{% from "backup_restic_minio/map.jinja" import config with context %}

docker-containers:
  lookup:
  {%- for app in config.targets %}
    {%- set db_config = config.get(app.get('db_type', 'postgres')) %}
    '{{ app.name }}':
      image: {{ db_config.image }}
      # Pull image on service restart
      # (useful if you override the same tag.  example: latest)
      pull_before_start: {{ db_config.pull_before_start }}
      # Remove container on service start
      remove_before_start: {{ db_config.remove_before_start }}
      # Do not force container removal on stop (unless true)
      remove_on_stop: {{ db_config.remove_on_stop }}
      {%- if app.command is defined and app.command|length %}cmd: {{ app.command }}{%- endif %}
      {%- if app.args is defined and app.args|length %}args: {{ app.args | list }}{%- endif %}
      {%- if app.run_ops is defined and app.run_ops|length %}
      runoptions: {{ app.run_ops }}
      {%- endif %}
      {%- if app.stop_ops is defined and app.stop_ops|length %}
      stopoptions: {{ app.stop_ops }}
      {%- endif %}
  {%- endfor %}