#!pydsl


def defaults(version):
    try:
        basics = __pillar__['postgresql']['basic_configuration']
    except:
        basics = {}

    try:
        locations = __pillar__['postgresql']['configuration_locations']
    except:
        locations = {}

    result = {
    'data_directory':        locations.get('data_directory',
                                         '/var/lib/postgresql/%s/main' % version),

    'unix_socket_directory': locations.get('unix_socket_directory',
                                           '/var/run/postgresql'),

    'postgresql_location':   locations.get('postgresql_location',
                                         '/etc/postgresql/%s/main/postgresql.conf' % version),

    'hba_location':          locations.get('hba_location',
                                         '/etc/postgresql/%s/main/pg_hba.conf' % version),

    'ident_location':        locations.get('ident_location',
                                         '/etc/postgresql/%s/main/pg_ident.conf' % version),

    'ctl_location':          locations.get('ctl_location',
                                         '/etc/postgresql/%s/main/pg_ctl.conf' % version),

    'listen_address':        basics.get('listen_address', '*'),
    'port':                  basics.get('port', '5432'),
    'version':               version,
    }

    return result