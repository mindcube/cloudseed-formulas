base:

  'master':
    - master

  'roles:lamp-basic':
    - match: grain
    - lamp-basic
    - mysql.server

  'roles:git-deploy':
    - match: grain
    - git-deploy

  'roles:mysql':
    - match: grain
    - mysql

  'roles:postgresql':
    - match: grain
    - postgresql