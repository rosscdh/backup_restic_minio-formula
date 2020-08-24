def test_file_exists(host):
    backup_restic_minio = host.file('/backup_restic_minio.yml')
    assert backup_restic_minio.exists
    assert backup_restic_minio.contains('your')

# def test_backup_restic_minio_is_installed(host):
#     backup_restic_minio = host.package('backup_restic_minio')
#     assert backup_restic_minio.is_installed
#
#
# def test_user_and_group_exist(host):
#     user = host.user('backup_restic_minio')
#     assert user.group == 'backup_restic_minio'
#     assert user.home == '/var/lib/backup_restic_minio'
#
#
# def test_service_is_running_and_enabled(host):
#     backup_restic_minio = host.service('backup_restic_minio')
#     assert backup_restic_minio.is_enabled
#     assert backup_restic_minio.is_running
