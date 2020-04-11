
pgrole="netdata"
image="netdata/netdata"
port_inside01="19999"
port_outside01="19999"

########################################################## YML EXPORT ##########
cat <<- EOF > "/pg/tmp/pgrole.yml"
- hosts: localhost
  gather_facts: false
  tasks:
    - name: 'Set Known Facts'
      set_fact:
        pgrole: 'netdata'

        image: 'netdata/netdata'

    # CORE (MANDATORY) ############################################################
    - name: 'Including cron job'
      include_tasks: '/pg/mods/apps/core.yml'

    # LABELS ######################################################################
    - name: 'Adding Traefik'
      set_fact:
        pg_labels:
          # traefik.frontend.auth.forward.address: '{{gauth}}'
          traefik.enable: 'true'
          traefik.port: '$port_inside'
          traefik.frontend.rule: 'Host:{{pgrole}}.{{domain.stdout}},{{tldset}}'
          traefik.frontend.headers.SSLHost: '{{domain.stdout}}'
          traefik.frontend.headers.SSLRedirect: 'true'
          traefik.frontend.headers.STSIncludeSubdomains: 'true'
          traefik.frontend.headers.STSPreload: 'true'
          traefik.frontend.headers.STSSeconds: '315360000'
          traefik.frontend.headers.browserXSSFilter: 'true'
          traefik.frontend.headers.contentTypeNosniff: 'true'
          traefik.frontend.headers.customResponseHeaders: 'X-Robots-Tag:noindex,nofollow,nosnippet,noarchive,notranslate,noimageindex'
          traefik.frontend.headers.forceSTSHeader: 'true'

    - name: 'Setting PG Volumes'
      set_fact:
        pg_volumes:
          - '/sys:/host/sys:ro'
          - '/proc:/host/proc:ro'
          - '/var/run/docker.sock:/var/run/docker.sock'

    - name: 'Setting PG ENV'
      set_fact:
        pg_env:
          PUID: '1000'
          PGID: '1000'

    # MAIN DEPLOYMENT #############################################################
    - name: 'Deploying {{pgrole}}'
      docker_container:
        name: '$pgrole'
        image: '$image'
        pull: yes
        capabilities:
          - SYS_PTRACE
        published_ports:
          - 127.0.0.1:$port_inside01:$port_outside01'
        volumes: '{{pg_volumes}}'
        env: '{{pg_env}}'
        restart_policy: unless-stopped
        networks:
          - name: plexguide
            aliases:
              - '{{pgrole}}'
        security_opts:
          - apparmor:unconfined
        state: started
        labels: '{{pg_labels}}'
EOL
