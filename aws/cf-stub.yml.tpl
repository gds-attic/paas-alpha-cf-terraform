---
director_uuid: BOSH_UUID
name: CloudFoundry
meta:
  environment: ${environment}
  zones:
    z1: "${zone0}"
    z2: "${zone1}"
  fog_config:
    region: "${region}"

resource_pools:
  - name: router_z1
    cloud_properties:
      elbs: ["${elb_name}"]
  - name: router_z2
    cloud_properties:
      elbs: ["${elb_name}"]

networks:
- name: cf1
  subnets:
    - range: 10.0.10.0/24
      gateway: 10.0.10.1
      dns: [10.0.0.2]
      reserved:
      - 10.0.10.2 - 10.0.10.9
      static:
      - 10.0.10.10 - 10.0.10.40
      cloud_properties:
        subnet: "${cf1_subnet_id}"
- name: cf2
  subnets:
    - range: 10.0.11.0/24
      gateway: 10.0.11.1
      reserved:
      - 10.0.11.2 - 10.0.11.9
      static:
      - 10.0.11.10 - 10.0.11.40
      cloud_properties:
        subnet: "${cf2_subnet_id}"

properties:
  cc:
    droplets:
      droplet_directory_key: "${environment}-cf-droplets"
    buildpacks:
      buildpack_directory_key: "${environment}-cf-buildpacks"
    resource_pool:
      resource_directory_key: "${environment}-cf-resources"
    packages:
      app_package_directory_key: "${environment}-cf-packages"
    staging_upload_user: username
    staging_upload_password: password
    bulk_api_password: password
    db_encryption_key: the_key
    min_cli_version: '6.1.0'
    min_recommended_cli_version: '6.10.0'
  ccdb:
    db_scheme: mysql
    roles:
    - tag: admin
      name: "${ccdb_username}"
      password: "${ccdb_password}"
    databases:
    - tag: cc
      name: ccdb
    address: "${ccdb_address}"
    port: 3306
  dea_next:
    disk_mb: 10240
    memory_mb: 4096
  nats:
    user: nats_user
    password: nats_password
  router:
    enable_ssl: true
    ssl_cert: |
      -----BEGIN CERTIFICATE-----
      MIIDBjCCAe4CCQCz3nn1SWrDdTANBgkqhkiG9w0BAQUFADBFMQswCQYDVQQGEwJB
      VTETMBEGA1UECBMKU29tZS1TdGF0ZTEhMB8GA1UEChMYSW50ZXJuZXQgV2lkZ2l0
      cyBQdHkgTHRkMB4XDTE1MDMwMzE4NTMyNloXDTE2MDMwMjE4NTMyNlowRTELMAkG
      A1UEBhMCQVUxEzARBgNVBAgTClNvbWUtU3RhdGUxITAfBgNVBAoTGEludGVybmV0
      IFdpZGdpdHMgUHR5IEx0ZDCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEB
      AKtTK9xq/ycRO3fWbk1abunYf9CY6sl0Wlqm9UPMkI4j0itY2OyGyn1YuCCiEdM3
      b8guGSWB0XSL5PBq33e7ioiaH98UEe+Ai+TBxnJsro5WQ/TMywzRDhZ4E7gxDBav
      88ZY+y7ts0HznfxqEIn0Gu/UK+s6ajYcIy7d9L988+hA3K1FSdes8MavXhrI4xA1
      fY21gESfFkD4SsqvrkISC012pa7oVw1f94slIVcAG+l9MMAkatBGxgWAQO6kxk5o
      oH1Z5q2m0afeQBfFqzu5lCITLfgTWCUZUmbF6UpRhmD850/LqNtryAPrLLqXxdig
      OHiWqvFpCusOu/4z1uGC5xECAwEAATANBgkqhkiG9w0BAQUFAAOCAQEAV5RAFVQy
      8Krs5c9ebYRseXO6czL9/Rfrt/weiC1XLcDkE2i2yYsBXazMYr58o4hACJwe2hoC
      bihBZ9XnVpASEYHDLwDj3zxFP/bTuKs7tLhP7wz0lo8i6k5VSPAGBq2kjc/cO9a3
      TMmLPks/Xm42MCSWGDnCEX1854B3+JK3CNEGqSY7FYXU4W9pZtHPZ3gBoy0ymSpg
      mpleiY1Tbn5I2X7vviMW7jeviB5ivkZaXtObjyM3vtPLB+ILpa15ZhDSE5o71sjA
      jXqrE1n5o/GXHX+1M8v3aJc30Az7QAqWohW/tw5SoiSmVQZWd7gFht9vSzaH2WgO
      LwcpBC7+cUJEww==
      -----END CERTIFICATE-----
    ssl_key: |
      -----BEGIN RSA PRIVATE KEY-----
      MIIEpAIBAAKCAQEAq1Mr3Gr/JxE7d9ZuTVpu6dh/0JjqyXRaWqb1Q8yQjiPSK1jY
      7IbKfVi4IKIR0zdvyC4ZJYHRdIvk8Grfd7uKiJof3xQR74CL5MHGcmyujlZD9MzL
      DNEOFngTuDEMFq/zxlj7Lu2zQfOd/GoQifQa79Qr6zpqNhwjLt30v3zz6EDcrUVJ
      16zwxq9eGsjjEDV9jbWARJ8WQPhKyq+uQhILTXalruhXDV/3iyUhVwAb6X0wwCRq
      0EbGBYBA7qTGTmigfVnmrabRp95AF8WrO7mUIhMt+BNYJRlSZsXpSlGGYPznT8uo
      22vIA+ssupfF2KA4eJaq8WkK6w67/jPW4YLnEQIDAQABAoIBAQCDVqpcOoZKK9K8
      Bt3eXQKEMJ2ji2cKczFFJ5MEm9EBtoJLCryZbqfSue3Fzpj9pBUEkBpk/4VT5F7o
      0/Vmc5Y7LHRcbqVlRtV30/lPBPQ4V/eWtly/AZDcNsdfP/J1fgPSvaoqCr2ORLWL
      qL/vEfyIeM4GcWy0+JMcPbmABslw9O6Ptc5RGiP98vCLHQh/++sOtj6PH1pt+2X/
      Uecv3b1Hk/3Oe+M8ySorJD3KA94QTRnKX+zubkxRg/zCAki+as8rQc/d+BfVG698
      ylUT5LVLNuwbWnffY2Zt5x5CDqH01mJnHmxzQEfn68rb3bGFaYPEn9EP+maQijv6
      SsUM9A3lAoGBAODRDRn4gEIxjPICp6aawRrMDlRc+k6IWDF7wudjxJlaxFr2t7FF
      rFYm+jrcG6qMTyq+teR8uHpcKm9X8ax0L6N6gw5rVzIeIOGma/ZuYIYXX2XJx5SW
      SOas1xW6qEIbOMv+Xu9w2SWbhTgyRmtlxxjr2e7gQLz9z/vuTReJpInnAoGBAMMW
      sq5lqUfAQzqxlhTobQ7tnB48rUQvkGPE92SlDj2TUt9phek2/TgRJT6mdcozvimt
      JPhxKg3ioxG8NPmN0EytjpSiKqlxS1R2po0fb75vputfpw16Z8/2Vik+xYqNMTLo
      SpeVkHu7fbtNYEK2qcU44OyOZ/V+5Oo9TuBIFRhHAoGACkqHhwDRHjaWdR2Z/w5m
      eIuOvF3lN2MWZm175ouynDKDeoaAsiS2VttB6R/aRFxX42UHfoYXC8LcTmyAK5zF
      8X3SMf7H5wtqBepQVt+Gm5zGSSqLcEnQ3H5c+impOh105CGoxt0rk4Ui/AeRIalv
      C70AJOcvD3eu5aFq9gDe/1ECgYBAhkVbASzYGnMh+pKVH7rScSxto8v6/XBYT1Ez
      7JOlMhD667/qvtFJtgIHkq7qzepbhnTv5x3tscQVnZY34/u9ILpD1s8dc+dibEvx
      6S/gYLVorB5ois/DLMqaobRcew6Gs+XX9RPwmLahOJpZ9mh4XrOmCgPAYtP71YM9
      ExpHCQKBgQCMMDDWGMRdFMJgXbx1uMere7OoniBdZaOexjbglRh1rMVSXqzBoU8+
      yhEuHGAsHGWQdSBHnqRe9O0Bj/Vlw2VVEaJeL1ewRHb+jXSnuKclZOJgMsJAvgGm
      SOWIahDrATA4g1T6yLBWQPhj3ZXD3eCMxT1Q3DvpG1DjgvXwmXQJAA==
      -----END RSA PRIVATE KEY-----
    cipher_suites: TLS_RSA_WITH_RC4_128_SHA:TLS_RSA_WITH_AES_128_CBC_SHA
    status:
      user: router_user
      password: router_password
  template_only:
    aws:
      access_key_id: "${aws_access_key_id}"
      secret_access_key: "${aws_secret_access_key}"
      availability_zone: "${zone0}"
      availability_zone2: "${zone1}"
  uaa:
    admin:
      client_secret: admin_secret
    batch:
      username: batch_username
      password: batch_password
    cc:
      client_secret: cc_client_secret
    clients:
      app-direct:
        secret: app-direct_secret
      developer_console:
        secret: developer_console_secret
      login:
        secret: login_client_secret
      notifications:
        secret: notification_secret
      doppler:
        secret: doppler_secret
      cloud_controller_username_lookup:
        secret: cloud_controller_username_lookup_secret
      gorouter:
        secret: gorouter_secret


    jwt:
      signing_key: |
        -----BEGIN RSA PRIVATE KEY-----
        MIICXAIBAAKBgQDHFr+KICms+tuT1OXJwhCUmR2dKVy7psa8xzElSyzqx7oJyfJ1
        JZyOzToj9T5SfTIq396agbHJWVfYphNahvZ/7uMXqHxf+ZH9BL1gk9Y6kCnbM5R6
        0gfwjyW1/dQPjOzn9N394zd2FJoFHwdq9Qs0wBugspULZVNRxq7veq/fzwIDAQAB
        AoGBAJ8dRTQFhIllbHx4GLbpTQsWXJ6w4hZvskJKCLM/o8R4n+0W45pQ1xEiYKdA
        Z/DRcnjltylRImBD8XuLL8iYOQSZXNMb1h3g5/UGbUXLmCgQLOUUlnYt34QOQm+0
        KvUqfMSFBbKMsYBAoQmNdTHBaz3dZa8ON9hh/f5TT8u0OWNRAkEA5opzsIXv+52J
        duc1VGyX3SwlxiE2dStW8wZqGiuLH142n6MKnkLU4ctNLiclw6BZePXFZYIK+AkE
        xQ+k16je5QJBAN0TIKMPWIbbHVr5rkdUqOyezlFFWYOwnMmw/BKa1d3zp54VP/P8
        +5aQ2d4sMoKEOfdWH7UqMe3FszfYFvSu5KMCQFMYeFaaEEP7Jn8rGzfQ5HQd44ek
        lQJqmq6CE2BXbY/i34FuvPcKU70HEEygY6Y9d8J3o6zQ0K9SYNu+pcXt4lkCQA3h
        jJQQe5uEGJTExqed7jllQ0khFJzLMx0K6tj0NeeIzAaGCQz13oo2sCdeGRHO4aDh
        HH6Qlq/6UOV5wP8+GAcCQFgRCcB+hrje8hfEEefHcFpyKH+5g1Eu1k0mLrxK2zd+
        4SlotYRHgPCEubokb2S1zfZDWIXW3HmggnGgM949TlY=
        -----END RSA PRIVATE KEY-----

      verification_key: |
        -----BEGIN PUBLIC KEY-----
        MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDHFr+KICms+tuT1OXJwhCUmR2d
        KVy7psa8xzElSyzqx7oJyfJ1JZyOzToj9T5SfTIq396agbHJWVfYphNahvZ/7uMX
        qHxf+ZH9BL1gk9Y6kCnbM5R60gfwjyW1/dQPjOzn9N394zd2FJoFHwdq9Qs0wBug
        spULZVNRxq7veq/fzwIDAQAB
        -----END PUBLIC KEY-----

    scim:
      users:
      - admin|fakepassword|scim.write,scim.read,openid,cloud_controller.admin,doppler.firehose
  loggregator_endpoint:
    shared_secret: secret
  uaadb:
    db_scheme: mysql
    roles:
    - tag: admin
      name: "${uaadb_username}"
      password: "${uaadb_password}"
    databases:
    - tag: uaa
      name: uaadb
    address: "${uaadb_address}"
    port: 3306
