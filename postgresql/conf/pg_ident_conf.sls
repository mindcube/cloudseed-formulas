#!pydsl


def postgresql_conf_ident(pg_utils):
    salt_postgres_version = __salt__['postgres.version']
    salt_get_managed =  __salt__['file.get_managed']
    salt_manage_file =  __salt__['file.manage_file']
    salt_cmd_run =  __salt__['cmd.run']

    try:
        configuration_sources = __pillar__['postgresql']['configuration_sources']
    except:
        configuration_sources = {}

    postgres_version = salt_postgres_version()
    if not postgres_version:
        postgres_version = salt_cmd_run(
            "psql --version | sed -E s/[^0-9\.]*//g | tr -d '\n'",
            shell='/bin/bash')

    version = '.'.join(postgres_version.split('.')[0:2])

    data = pg_utils.defaults(version)

    target = data['ident_location']
    env = 'base'

    source = configuration_sources.get(
        'pg_ident',
        'salt://postgresql/files/pg_ident.conf')

    sfn, source_sum, _ = salt_get_managed(
        name=target,
        template='jinja',
        source=source,
        source_hash=None,
        user='postgres',
        group='postgres',
        mode='644',
        env=env,
        context=None,
        defaults=None)

    return salt_manage_file(
        name=target,
        sfn=sfn,
        ret=None,
        source=source,
        source_sum=source_sum,
        user='postgres',
        group='postgres',
        mode='644',
        env=env,
        backup='',
        template='jinja')


def states(pg_utils):
    state('postgresql.conf.ident') \
        .cmd.call(postgresql_conf_ident, pg_utils) \
        .require(pkg='postgresql.core',
                 cmd='postgresql_conf_data_dir') \
        .watch_in(service='postgresql.service')
