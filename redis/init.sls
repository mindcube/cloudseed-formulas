{% from "redis/map.jinja" import redis with context %}

redis:
  pkg:
    - installed
    - name: {{ redis.package }}
  service:
    - running
    - name: {{ redis.service }}
    - enable: True
    - watch:
      - pkg: {{ redis.package }}
      - file: redis.conf

redis.conf:
  file.managed:
    - name: {{ redis.config }}
    - source: {{ pillar.get('redis')['conf']|d('salt://redis/files/redis.conf') }}
    - user: root
    - group: root
    - mode: 644
