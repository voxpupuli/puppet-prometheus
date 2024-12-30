# Changelog

All notable changes to this project will be documented in this file.
Each new release typically also includes the latest modulesync defaults.
These should not affect the functionality of the module.

## [v16.0.0](https://github.com/voxpupuli/puppet-prometheus/tree/v16.0.0) (2024-12-30)

[Full Changelog](https://github.com/voxpupuli/puppet-prometheus/compare/v15.0.0...v16.0.0)

**Breaking changes:**

- remove support for apache\_exporter \< 1.0.0 [\#826](https://github.com/voxpupuli/puppet-prometheus/pull/826) ([TheMeier](https://github.com/TheMeier))
- remove code options for elasticsearch\_exporter \< 1.1.0 [\#804](https://github.com/voxpupuli/puppet-prometheus/pull/804) ([TheMeier](https://github.com/TheMeier))
- Update dependency prometheus/snmp\_exporter to v0.26.0 [\#774](https://github.com/voxpupuli/puppet-prometheus/pull/774) ([pccibot](https://github.com/pccibot))

**Implemented enhancements:**

- add options to set tls parameters for mysql config used by mysqld\_exporter [\#832](https://github.com/voxpupuli/puppet-prometheus/pull/832) ([TheMeier](https://github.com/TheMeier))
- manage homedirectory for prometheus user when manage\_user is true [\#831](https://github.com/voxpupuli/puppet-prometheus/pull/831) ([TheMeier](https://github.com/TheMeier))
- use default modulesync template for ci.yml [\#830](https://github.com/voxpupuli/puppet-prometheus/pull/830) ([TheMeier](https://github.com/TheMeier))
- puppet/systemd: allow 8.x [\#823](https://github.com/voxpupuli/puppet-prometheus/pull/823) ([jay7x](https://github.com/jay7x))
- use $service\_name instead of a hard-coded name for prometheus::daemon [\#803](https://github.com/voxpupuli/puppet-prometheus/pull/803) ([saz](https://github.com/saz))
- Replace hardcoded mysqld\_exporter service name with $service\_name variable [\#802](https://github.com/voxpupuli/puppet-prometheus/pull/802) ([saz](https://github.com/saz))
- feat: move all exporter version from data into the manifests [\#800](https://github.com/voxpupuli/puppet-prometheus/pull/800) ([TheMeier](https://github.com/TheMeier))
- feat: add --web.listen-address flag to node\_exporter if the scrape port is changed [\#799](https://github.com/voxpupuli/puppet-prometheus/pull/799) ([TheMeier](https://github.com/TheMeier))
- Update nginx\_prometheus\_exporter.pp to use proxy server [\#796](https://github.com/voxpupuli/puppet-prometheus/pull/796) ([schiznik](https://github.com/schiznik))
- expose the env\_vars and env\_file\_path parameters to the blackbox\_exporter [\#791](https://github.com/voxpupuli/puppet-prometheus/pull/791) ([lukebigum](https://github.com/lukebigum))
- support the new scrape\_config\_files option, prom ~v2.45 [\#782](https://github.com/voxpupuli/puppet-prometheus/pull/782) ([lukebigum](https://github.com/lukebigum))
- Update dependency treydock/ssh\_exporter to v1.5.0 [\#779](https://github.com/voxpupuli/puppet-prometheus/pull/779) ([pccibot](https://github.com/pccibot))
- Update dependency tomcz/openldap\_exporter to v2.2.2 [\#778](https://github.com/voxpupuli/puppet-prometheus/pull/778) ([pccibot](https://github.com/pccibot))
- Update dependency ribbybibby/ssl\_exporter to v2.4.3 [\#776](https://github.com/voxpupuli/puppet-prometheus/pull/776) ([pccibot](https://github.com/pccibot))
- Update dependency prometheus/statsd\_exporter to v0.26.1 [\#775](https://github.com/voxpupuli/puppet-prometheus/pull/775) ([pccibot](https://github.com/pccibot))
- Update dependency prometheus/pushgateway to v1.9.0 [\#773](https://github.com/voxpupuli/puppet-prometheus/pull/773) ([pccibot](https://github.com/pccibot))
- Update dependency prometheus/node\_exporter to v1.8.1 [\#772](https://github.com/voxpupuli/puppet-prometheus/pull/772) ([pccibot](https://github.com/pccibot))
- Update dependency prometheus/mysqld\_exporter to v0.15.1 [\#771](https://github.com/voxpupuli/puppet-prometheus/pull/771) ([pccibot](https://github.com/pccibot))
- Update dependency prometheus/memcached\_exporter to v0.14.4 [\#770](https://github.com/voxpupuli/puppet-prometheus/pull/770) ([pccibot](https://github.com/pccibot))
- Update dependency prometheus/haproxy\_exporter to v0.15.0 [\#769](https://github.com/voxpupuli/puppet-prometheus/pull/769) ([pccibot](https://github.com/pccibot))
- deprecate nginx-vts-exporter [\#768](https://github.com/voxpupuli/puppet-prometheus/pull/768) ([pccibot](https://github.com/pccibot))
- Update dependency prometheus/graphite\_exporter to v0.15.1 [\#767](https://github.com/voxpupuli/puppet-prometheus/pull/767) ([pccibot](https://github.com/pccibot))
- Update dependency prometheus/consul\_exporter to v0.12.0 [\#763](https://github.com/voxpupuli/puppet-prometheus/pull/763) ([pccibot](https://github.com/pccibot))
- Update dependency prometheus/collectd\_exporter to v0.6.0 [\#762](https://github.com/voxpupuli/puppet-prometheus/pull/762) ([pccibot](https://github.com/pccibot))
- Update dependency prometheus/blackbox\_exporter to v0.25.0 [\#761](https://github.com/voxpupuli/puppet-prometheus/pull/761) ([pccibot](https://github.com/pccibot))
- Update dependency prometheus-community/ipmi\_exporter to v1.8.0 [\#759](https://github.com/voxpupuli/puppet-prometheus/pull/759) ([pccibot](https://github.com/pccibot))
- Update dependency prometheus-community/bind\_exporter to v0.7.0 [\#758](https://github.com/voxpupuli/puppet-prometheus/pull/758) ([pccibot](https://github.com/pccibot))
- Update dependency prometheus-community/PushProx to v0.2.0 [\#757](https://github.com/voxpupuli/puppet-prometheus/pull/757) ([pccibot](https://github.com/pccibot))
- Update dependency povilasv/systemd\_exporter to v0.6.0 [\#756](https://github.com/voxpupuli/puppet-prometheus/pull/756) ([pccibot](https://github.com/pccibot))
- Update dependency percona/mongodb\_exporter to v0.40.0 [\#755](https://github.com/voxpupuli/puppet-prometheus/pull/755) ([pccibot](https://github.com/pccibot))
- Update dependency oliver006/redis\_exporter to v1.61.0 [\#754](https://github.com/voxpupuli/puppet-prometheus/pull/754) ([pccibot](https://github.com/pccibot))
- Update dependency nginxinc/nginx-prometheus-exporter to v0.11.0 [\#751](https://github.com/voxpupuli/puppet-prometheus/pull/751) ([github-actions[bot]](https://github.com/apps/github-actions))
- Update dependency ncabatoff/process-exporter to v0.8.2 [\#750](https://github.com/voxpupuli/puppet-prometheus/pull/750) ([github-actions[bot]](https://github.com/apps/github-actions))
- Update dependency kumina/unbound\_exporter to v0.4.6 [\#749](https://github.com/voxpupuli/puppet-prometheus/pull/749) ([github-actions[bot]](https://github.com/apps/github-actions))
- Update dependency justwatchcom/elasticsearch\_exporter to v1.7.0 [\#748](https://github.com/voxpupuli/puppet-prometheus/pull/748) ([github-actions[bot]](https://github.com/apps/github-actions))
- Update dependency jonnenauha/prometheus\_varnish\_exporter to v1.6.1 [\#747](https://github.com/voxpupuli/puppet-prometheus/pull/747) ([github-actions[bot]](https://github.com/apps/github-actions))
- Update dependency hipages/php-fpm\_exporter to v2.2.0 [\#746](https://github.com/voxpupuli/puppet-prometheus/pull/746) ([github-actions[bot]](https://github.com/apps/github-actions))
- Update dependency galexrt/dellhw\_exporter to v1.13.12 [\#745](https://github.com/voxpupuli/puppet-prometheus/pull/745) ([github-actions[bot]](https://github.com/apps/github-actions))
- Update dependency dennisstritzke/ipsec\_exporter to v0.4.0 [\#744](https://github.com/voxpupuli/puppet-prometheus/pull/744) ([github-actions[bot]](https://github.com/apps/github-actions))
- Add iperf3 exporter [\#608](https://github.com/voxpupuli/puppet-prometheus/pull/608) ([onstring](https://github.com/onstring))

**Fixed bugs:**

- Fix scrape\_job\_name for openvpn exporter [\#812](https://github.com/voxpupuli/puppet-prometheus/pull/812) ([drkp](https://github.com/drkp))
- fix: missing `WorkDirectory` in systemd unit file for archliinux [\#793](https://github.com/voxpupuli/puppet-prometheus/pull/793) ([TheMeier](https://github.com/TheMeier))

**Closed issues:**

- keeping exporter versions up-to-date [\#666](https://github.com/voxpupuli/puppet-prometheus/issues/666)
- mysqld\_exporter configuration for ssl not possible [\#604](https://github.com/voxpupuli/puppet-prometheus/issues/604)

**Merged pull requests:**

- Make documentation on collect\_scrape\_jobs clearer [\#811](https://github.com/voxpupuli/puppet-prometheus/pull/811) ([j-dr3](https://github.com/j-dr3))

## [v15.0.0](https://github.com/voxpupuli/puppet-prometheus/tree/v15.0.0) (2024-06-13)

[Full Changelog](https://github.com/voxpupuli/puppet-prometheus/compare/v14.0.0...v15.0.0)

**Breaking changes:**

- Remove support for alertmanager \< 0.13.0 [\#720](https://github.com/voxpupuli/puppet-prometheus/issues/720)
- Remove prometheus 1.x support [\#718](https://github.com/voxpupuli/puppet-prometheus/issues/718)
- Change default port from 9090 to 9419 [\#637](https://github.com/voxpupuli/puppet-prometheus/pull/637) ([mindriot88](https://github.com/mindriot88))
- drop suport for redis\_exporter \< 1.0.0 [\#732](https://github.com/voxpupuli/puppet-prometheus/pull/732) ([TheMeier](https://github.com/TheMeier))
- drop support for alertmanager \< 0.13.0 [\#731](https://github.com/voxpupuli/puppet-prometheus/pull/731) ([TheMeier](https://github.com/TheMeier))
- drop support for prometheus 1.x, update prometheus version to 2.52.0 [\#728](https://github.com/voxpupuli/puppet-prometheus/pull/728) ([TheMeier](https://github.com/TheMeier))
- drop Debian 10 support [\#727](https://github.com/voxpupuli/puppet-prometheus/pull/727) ([TheMeier](https://github.com/TheMeier))
- drop RedHat and CentOS 7 & 8 support [\#726](https://github.com/voxpupuli/puppet-prometheus/pull/726) ([TheMeier](https://github.com/TheMeier))
- update alertmanager to 0.21.0-\>0.27.0 [\#725](https://github.com/voxpupuli/puppet-prometheus/pull/725) ([TheMeier](https://github.com/TheMeier))

**Implemented enhancements:**

- deprecation of `source_match(_re)` and `target_match(_re)`  [\#697](https://github.com/voxpupuli/puppet-prometheus/issues/697)
- replace templates for systemd units with systemd::manage\_unit [\#735](https://github.com/voxpupuli/puppet-prometheus/pull/735) ([TheMeier](https://github.com/TheMeier))
- remove code for puppet \< 7 [\#724](https://github.com/voxpupuli/puppet-prometheus/pull/724) ([TheMeier](https://github.com/TheMeier))
- Fix Archlinux acceptance test [\#719](https://github.com/voxpupuli/puppet-prometheus/pull/719) ([TheMeier](https://github.com/TheMeier))
- update puppet-systemd upper bound to 8.0.0 [\#716](https://github.com/voxpupuli/puppet-prometheus/pull/716) ([TheMeier](https://github.com/TheMeier))

**Fixed bugs:**

- fix syntax of altermanager::receivers [\#723](https://github.com/voxpupuli/puppet-prometheus/pull/723) ([TheMeier](https://github.com/TheMeier))
- change path or my.cnf for mysqld\_exporter [\#722](https://github.com/voxpupuli/puppet-prometheus/pull/722) ([TheMeier](https://github.com/TheMeier))

## [v14.0.0](https://github.com/voxpupuli/puppet-prometheus/tree/v14.0.0) (2024-03-26)

[Full Changelog](https://github.com/voxpupuli/puppet-prometheus/compare/v13.4.0...v14.0.0)

**Breaking changes:**

- Drop Ubuntu 18.04, allow systemd 6.x [\#704](https://github.com/voxpupuli/puppet-prometheus/pull/704) ([griggi-ws](https://github.com/griggi-ws))
- Rework web-config support for multiple exporters [\#693](https://github.com/voxpupuli/puppet-prometheus/pull/693) ([cruelsmith](https://github.com/cruelsmith))

**Implemented enhancements:**

- add option to enable tracing in Prometheus config [\#705](https://github.com/voxpupuli/puppet-prometheus/pull/705) ([fbegyn](https://github.com/fbegyn))
- Add Debian 12 support [\#703](https://github.com/voxpupuli/puppet-prometheus/pull/703) ([bastelfreak](https://github.com/bastelfreak))
- Cleanup architecture selection, dont fail on unknown architecture [\#702](https://github.com/voxpupuli/puppet-prometheus/pull/702) ([bastelfreak](https://github.com/bastelfreak))
- mongodb\_exporter: make service name and binary path configureable [\#699](https://github.com/voxpupuli/puppet-prometheus/pull/699) ([ansgarwiechers](https://github.com/ansgarwiechers))
- Implement wireguard exporter [\#695](https://github.com/voxpupuli/puppet-prometheus/pull/695) ([bastelfreak](https://github.com/bastelfreak))
- Add OracleLinux support [\#687](https://github.com/voxpupuli/puppet-prometheus/pull/687) ([bastelfreak](https://github.com/bastelfreak))

**Merged pull requests:**

- Remove legacy top-scope syntax [\#706](https://github.com/voxpupuli/puppet-prometheus/pull/706) ([smortex](https://github.com/smortex))

## [v13.4.0](https://github.com/voxpupuli/puppet-prometheus/tree/v13.4.0) (2023-11-08)

[Full Changelog](https://github.com/voxpupuli/puppet-prometheus/compare/v13.3.0...v13.4.0)

**Implemented enhancements:**

- Update puppet-strings documentation [\#700](https://github.com/voxpupuli/puppet-prometheus/pull/700) ([JGodin-C2C](https://github.com/JGodin-C2C))
- Add systemd\_exporter [\#661](https://github.com/voxpupuli/puppet-prometheus/pull/661) ([JGodin-C2C](https://github.com/JGodin-C2C))

## [v13.3.0](https://github.com/voxpupuli/puppet-prometheus/tree/v13.3.0) (2023-08-19)

[Full Changelog](https://github.com/voxpupuli/puppet-prometheus/compare/v13.2.0...v13.3.0)

**Implemented enhancements:**

- Drop legacy systemd reload code for Puppet 5 [\#689](https://github.com/voxpupuli/puppet-prometheus/pull/689) ([bastelfreak](https://github.com/bastelfreak))
- add proxy\_server & proxy\_type to server install [\#641](https://github.com/voxpupuli/puppet-prometheus/pull/641) ([sabo](https://github.com/sabo))

**Fixed bugs:**

- Fix Arch Linux Prometheus Server installation [\#684](https://github.com/voxpupuli/puppet-prometheus/pull/684) ([bastelfreak](https://github.com/bastelfreak))

**Merged pull requests:**

- init.pp: Add default data from hiera [\#686](https://github.com/voxpupuli/puppet-prometheus/pull/686) ([bastelfreak](https://github.com/bastelfreak))

## [v13.2.0](https://github.com/voxpupuli/puppet-prometheus/tree/v13.2.0) (2023-07-29)

[Full Changelog](https://github.com/voxpupuli/puppet-prometheus/compare/v13.1.0...v13.2.0)

**Merged pull requests:**

- systemd & archive: Allow latest deps [\#682](https://github.com/voxpupuli/puppet-prometheus/pull/682) ([bastelfreak](https://github.com/bastelfreak))

## [v13.1.0](https://github.com/voxpupuli/puppet-prometheus/tree/v13.1.0) (2023-07-13)

[Full Changelog](https://github.com/voxpupuli/puppet-prometheus/compare/v13.0.0...v13.1.0)

**Implemented enhancements:**

- remove legacy function has\_keys [\#678](https://github.com/voxpupuli/puppet-prometheus/pull/678) ([marszip](https://github.com/marszip))

## [v13.0.0](https://github.com/voxpupuli/puppet-prometheus/tree/v13.0.0) (2023-06-26)

[Full Changelog](https://github.com/voxpupuli/puppet-prometheus/compare/v12.5.0...v13.0.0)

**Breaking changes:**

- Drop Ubuntu 16.04 \(EOL\) [\#668](https://github.com/voxpupuli/puppet-prometheus/pull/668) ([smortex](https://github.com/smortex))
- Drop Debian 9 \(EOL\) [\#667](https://github.com/voxpupuli/puppet-prometheus/pull/667) ([smortex](https://github.com/smortex))
- puppetlabs/stdlib: Require 9.x [\#665](https://github.com/voxpupuli/puppet-prometheus/pull/665) ([hashworks](https://github.com/hashworks))
- Drop Puppet 6 support [\#660](https://github.com/voxpupuli/puppet-prometheus/pull/660) ([bastelfreak](https://github.com/bastelfreak))

**Implemented enhancements:**

- Add Ubuntu 22.04 support [\#672](https://github.com/voxpupuli/puppet-prometheus/pull/672) ([bastelfreak](https://github.com/bastelfreak))
- Add EL9 support [\#671](https://github.com/voxpupuli/puppet-prometheus/pull/671) ([bastelfreak](https://github.com/bastelfreak))
- Add puppet 8 support [\#670](https://github.com/voxpupuli/puppet-prometheus/pull/670) ([bastelfreak](https://github.com/bastelfreak))

**Merged pull requests:**

- blackbox\_exporter: Move hiera data to class [\#675](https://github.com/voxpupuli/puppet-prometheus/pull/675) ([bastelfreak](https://github.com/bastelfreak))
- postgres\_exporter: Move hiera data to class [\#674](https://github.com/voxpupuli/puppet-prometheus/pull/674) ([bastelfreak](https://github.com/bastelfreak))
- redis\_exporter: Move hiera data to class [\#673](https://github.com/voxpupuli/puppet-prometheus/pull/673) ([bastelfreak](https://github.com/bastelfreak))

## [v12.5.0](https://github.com/voxpupuli/puppet-prometheus/tree/v12.5.0) (2023-01-30)

[Full Changelog](https://github.com/voxpupuli/puppet-prometheus/compare/v12.4.0...v12.5.0)

**Implemented enhancements:**

- Add AlmaLinux/Rocky 8 support [\#649](https://github.com/voxpupuli/puppet-prometheus/pull/649) ([bastelfreak](https://github.com/bastelfreak))
- bump puppet/systemd to \< 5.0.0 [\#645](https://github.com/voxpupuli/puppet-prometheus/pull/645) ([jhoblitt](https://github.com/jhoblitt))
- Adapt web.config.file option for node\_exporter versions higher than 1.5.0 [\#644](https://github.com/voxpupuli/puppet-prometheus/pull/644) ([Pigueiras](https://github.com/Pigueiras))
- feat: Support JMX exporter [\#636](https://github.com/voxpupuli/puppet-prometheus/pull/636) ([dploeger](https://github.com/dploeger))
- Support time\_intervals with alertmanager \>= 0.24.0 [\#618](https://github.com/voxpupuli/puppet-prometheus/pull/618) ([treydock](https://github.com/treydock))

**Fixed bugs:**

- Replace $facts\['service\_provider'\] by $prometheus::init\_style \(except init.pp\) [\#642](https://github.com/voxpupuli/puppet-prometheus/pull/642) ([phaedriel](https://github.com/phaedriel))

**Closed issues:**

- Support JMX exporter [\#635](https://github.com/voxpupuli/puppet-prometheus/issues/635)
- Toplevel parameter init\_style ignored [\#629](https://github.com/voxpupuli/puppet-prometheus/issues/629)

**Merged pull requests:**

- varnish\_exporter: Move hiera data to class [\#653](https://github.com/voxpupuli/puppet-prometheus/pull/653) ([bastelfreak](https://github.com/bastelfreak))
- graphite\_exporter: Move hiera data to class [\#652](https://github.com/voxpupuli/puppet-prometheus/pull/652) ([bastelfreak](https://github.com/bastelfreak))
- collectd\_exporter: Move hiera data to class [\#651](https://github.com/voxpupuli/puppet-prometheus/pull/651) ([bastelfreak](https://github.com/bastelfreak))
- apache\_exporter: Move hiera data to class [\#650](https://github.com/voxpupuli/puppet-prometheus/pull/650) ([bastelfreak](https://github.com/bastelfreak))
- config\_file: Enforce Stdlib::Absolutepath [\#648](https://github.com/voxpupuli/puppet-prometheus/pull/648) ([bastelfreak](https://github.com/bastelfreak))
- grok\_exporter: Move hiera data to class [\#647](https://github.com/voxpupuli/puppet-prometheus/pull/647) ([bastelfreak](https://github.com/bastelfreak))
- Debian OS family: Install apt-transport-https during CI [\#628](https://github.com/voxpupuli/puppet-prometheus/pull/628) ([bastelfreak](https://github.com/bastelfreak))
- prometheus: Move hiera data to class [\#624](https://github.com/voxpupuli/puppet-prometheus/pull/624) ([bastelfreak](https://github.com/bastelfreak))

## [v12.4.0](https://github.com/voxpupuli/puppet-prometheus/tree/v12.4.0) (2022-06-03)

[Full Changelog](https://github.com/voxpupuli/puppet-prometheus/compare/v12.3.0...v12.4.0)

**Implemented enhancements:**

- Adding a Proxy option [\#186](https://github.com/voxpupuli/puppet-prometheus/issues/186)
- Implement web-config.yml handling [\#622](https://github.com/voxpupuli/puppet-prometheus/pull/622) ([rwaffen](https://github.com/rwaffen))
- Support new download format for openldap\_exporter [\#619](https://github.com/voxpupuli/puppet-prometheus/pull/619) ([treydock](https://github.com/treydock))
- Add php-fpm exporter [\#605](https://github.com/voxpupuli/puppet-prometheus/pull/605) ([kubicgruenfeld](https://github.com/kubicgruenfeld))
- Add Debian 11 support [\#601](https://github.com/voxpupuli/puppet-prometheus/pull/601) ([towo](https://github.com/towo))
- Allow to set storage parameters to false [\#598](https://github.com/voxpupuli/puppet-prometheus/pull/598) ([kubicgruenfeld](https://github.com/kubicgruenfeld))
- \(\#186\) Add proxy parameters [\#596](https://github.com/voxpupuli/puppet-prometheus/pull/596) ([ShaunMaxwell](https://github.com/ShaunMaxwell))

**Fixed bugs:**

- make process exporter service name propagate correctly [\#617](https://github.com/voxpupuli/puppet-prometheus/pull/617) ([anarcat](https://github.com/anarcat))

**Closed issues:**

- We should be able to download from custom url with credentials [\#603](https://github.com/voxpupuli/puppet-prometheus/issues/603)
- Prometheus Agent mode not supported yet [\#597](https://github.com/voxpupuli/puppet-prometheus/issues/597)
- Support for node exporter 1.x [\#520](https://github.com/voxpupuli/puppet-prometheus/issues/520)

**Merged pull requests:**

- Update ipmi\_exporter URL, project moved [\#620](https://github.com/voxpupuli/puppet-prometheus/pull/620) ([treydock](https://github.com/treydock))
- extra\_options: Switch from String to Optional\[String\[1\]\] [\#610](https://github.com/voxpupuli/puppet-prometheus/pull/610) ([bastelfreak](https://github.com/bastelfreak))
- Beaker: Install lsb-release during CI [\#609](https://github.com/voxpupuli/puppet-prometheus/pull/609) ([bastelfreak](https://github.com/bastelfreak))

## [v12.3.0](https://github.com/voxpupuli/puppet-prometheus/tree/v12.3.0) (2021-11-17)

[Full Changelog](https://github.com/voxpupuli/puppet-prometheus/compare/v12.2.0...v12.3.0)

**Implemented enhancements:**

- Add a parameter to validate alertmanager config [\#593](https://github.com/voxpupuli/puppet-prometheus/pull/593) ([roidelapluie](https://github.com/roidelapluie))
- Add sachet webhook receiver [\#590](https://github.com/voxpupuli/puppet-prometheus/pull/590) ([BDelacour](https://github.com/BDelacour))

**Fixed bugs:**

- fix download url for new asset url schema [\#591](https://github.com/voxpupuli/puppet-prometheus/pull/591) ([reini-1](https://github.com/reini-1))

**Closed issues:**

- Alertmanager configuration is not checked when installed from RPM [\#592](https://github.com/voxpupuli/puppet-prometheus/issues/592)
- postgres\_exporter 0.10.0 cannot be downloaded [\#584](https://github.com/voxpupuli/puppet-prometheus/issues/584)
- found multiple scrape configs with job name `x` [\#573](https://github.com/voxpupuli/puppet-prometheus/issues/573)

**Merged pull requests:**

- Update prometheus version from 2.20.1 to 2.30.3 [\#587](https://github.com/voxpupuli/puppet-prometheus/pull/587) ([saz](https://github.com/saz))
- Run CI nightly [\#586](https://github.com/voxpupuli/puppet-prometheus/pull/586) ([bastelfreak](https://github.com/bastelfreak))

## [v12.2.0](https://github.com/voxpupuli/puppet-prometheus/tree/v12.2.0) (2021-10-04)

[Full Changelog](https://github.com/voxpupuli/puppet-prometheus/compare/v12.1.1...v12.2.0)

**Implemented enhancements:**

- add nginx exporter [\#583](https://github.com/voxpupuli/puppet-prometheus/pull/583) ([kubicgruenfeld](https://github.com/kubicgruenfeld))

**Fixed bugs:**

- conflict with camptocamp-systemd latest  release 3.0.0 [\#560](https://github.com/voxpupuli/puppet-prometheus/issues/560)

## [v12.1.1](https://github.com/voxpupuli/puppet-prometheus/tree/v12.1.1) (2021-08-26)

[Full Changelog](https://github.com/voxpupuli/puppet-prometheus/compare/v12.1.0...v12.1.1)

**Merged pull requests:**

- Allow up-to-date dependencies [\#579](https://github.com/voxpupuli/puppet-prometheus/pull/579) ([smortex](https://github.com/smortex))

## [v12.1.0](https://github.com/voxpupuli/puppet-prometheus/tree/v12.1.0) (2021-08-24)

[Full Changelog](https://github.com/voxpupuli/puppet-prometheus/compare/v12.0.0...v12.1.0)

**Implemented enhancements:**

- $bin\_dir: Update datatype to Stdlib::Absolutepath [\#575](https://github.com/voxpupuli/puppet-prometheus/pull/575) ([bastelfreak](https://github.com/bastelfreak))
- Arch Linux: Install bird\_exporter via packages [\#574](https://github.com/voxpupuli/puppet-prometheus/pull/574) ([bastelfreak](https://github.com/bastelfreak))

**Fixed bugs:**

- Arch Linux: Fix node\_exporter installation [\#576](https://github.com/voxpupuli/puppet-prometheus/pull/576) ([bastelfreak](https://github.com/bastelfreak))

## [v12.0.0](https://github.com/voxpupuli/puppet-prometheus/tree/v12.0.0) (2021-07-27)

[Full Changelog](https://github.com/voxpupuli/puppet-prometheus/compare/v11.2.0...v12.0.0)

**Breaking changes:**

- Overhaul and fix ipmi\_exporter class [\#562](https://github.com/voxpupuli/puppet-prometheus/pull/562) ([treydock](https://github.com/treydock))

**Implemented enhancements:**

- Support SSL exporter [\#567](https://github.com/voxpupuli/puppet-prometheus/pull/567) ([treydock](https://github.com/treydock))
- Add support for SSH exporter [\#566](https://github.com/voxpupuli/puppet-prometheus/pull/566) ([treydock](https://github.com/treydock))
- Support mute\_time\_intervals for Alertmanager [\#563](https://github.com/voxpupuli/puppet-prometheus/pull/563) ([treydock](https://github.com/treydock))
- Support Stdlib::Filesource as type for download urls [\#561](https://github.com/voxpupuli/puppet-prometheus/pull/561) ([gburton1](https://github.com/gburton1))

**Fixed bugs:**

- Fix wrong undef datatypes [\#570](https://github.com/voxpupuli/puppet-prometheus/pull/570) ([bastelfreak](https://github.com/bastelfreak))

**Closed issues:**

- Alertmanger service will not start \(public IP\) [\#558](https://github.com/voxpupuli/puppet-prometheus/issues/558)

**Merged pull requests:**

- switch from camptocamp/systemd to voxpupuli/systemd [\#569](https://github.com/voxpupuli/puppet-prometheus/pull/569) ([bastelfreak](https://github.com/bastelfreak))
- Fix IPMI exporter sudo config, add dependency on saz/sudo [\#565](https://github.com/voxpupuli/puppet-prometheus/pull/565) ([treydock](https://github.com/treydock))
- Misc fixes to make IPMI exporter more consistent [\#564](https://github.com/voxpupuli/puppet-prometheus/pull/564) ([treydock](https://github.com/treydock))
- Allow default scrape\_configs to be optional [\#542](https://github.com/voxpupuli/puppet-prometheus/pull/542) ([treydock](https://github.com/treydock))

## [v11.2.0](https://github.com/voxpupuli/puppet-prometheus/tree/v11.2.0) (2021-06-09)

[Full Changelog](https://github.com/voxpupuli/puppet-prometheus/compare/v11.1.0...v11.2.0)

**Implemented enhancements:**

- Exporters: Use Prometheus::Initstyle for $init\_style [\#557](https://github.com/voxpupuli/puppet-prometheus/pull/557) ([bastelfreak](https://github.com/bastelfreak))
- Exporters: Use Prometheus::Install for $install\_method [\#556](https://github.com/voxpupuli/puppet-prometheus/pull/556) ([bastelfreak](https://github.com/bastelfreak))
- Exporters: Use Prometheus::Uri for $download\_url\_base [\#554](https://github.com/voxpupuli/puppet-prometheus/pull/554) ([bastelfreak](https://github.com/bastelfreak))
- Add openvpn\_exporter [\#553](https://github.com/voxpupuli/puppet-prometheus/pull/553) ([JosephKav](https://github.com/JosephKav))
- mongodb\_exporter supporting newer versions [\#550](https://github.com/voxpupuli/puppet-prometheus/pull/550) ([kuldazbraslav](https://github.com/kuldazbraslav))
- Add openldap\_exporter [\#549](https://github.com/voxpupuli/puppet-prometheus/pull/549) ([dabelenda](https://github.com/dabelenda))
- Add ipsec\_exporter [\#547](https://github.com/voxpupuli/puppet-prometheus/pull/547) ([kuldazbraslav](https://github.com/kuldazbraslav))

**Merged pull requests:**

- Exporters: Use Optional\[Prometheus::Uri\] for $download\_url [\#555](https://github.com/voxpupuli/puppet-prometheus/pull/555) ([bastelfreak](https://github.com/bastelfreak))

## [v11.1.0](https://github.com/voxpupuli/puppet-prometheus/tree/v11.1.0) (2021-04-25)

[Full Changelog](https://github.com/voxpupuli/puppet-prometheus/compare/v11.0.0...v11.1.0)

**Implemented enhancements:**

- puppetlabs/stdlib: Allow 7.x [\#545](https://github.com/voxpupuli/puppet-prometheus/pull/545) ([bastelfreak](https://github.com/bastelfreak))
- camptocamp/systemd: allow 3.x [\#544](https://github.com/voxpupuli/puppet-prometheus/pull/544) ([bastelfreak](https://github.com/bastelfreak))
- puppet/archive: allow 5.x [\#543](https://github.com/voxpupuli/puppet-prometheus/pull/543) ([bastelfreak](https://github.com/bastelfreak))
- bird\_exporter: Update 1.2.4 -\> 1.2.5 [\#538](https://github.com/voxpupuli/puppet-prometheus/pull/538) ([bastelfreak](https://github.com/bastelfreak))
- Implement unbound\_exporter [\#498](https://github.com/voxpupuli/puppet-prometheus/pull/498) ([bastelfreak](https://github.com/bastelfreak))
- Add Bind exporter [\#312](https://github.com/voxpupuli/puppet-prometheus/pull/312) ([anarcat](https://github.com/anarcat))

**Fixed bugs:**

- fix quoting in apache exporter [\#541](https://github.com/voxpupuli/puppet-prometheus/pull/541) ([anarcat](https://github.com/anarcat))
- fix default scrape\_uri in apache\_exporter [\#532](https://github.com/voxpupuli/puppet-prometheus/pull/532) ([anarcat](https://github.com/anarcat))
- Fix download of beanstalkd\_exporter for versions newer than 1.0.0 [\#508](https://github.com/voxpupuli/puppet-prometheus/pull/508) ([TuningYourCode](https://github.com/TuningYourCode))
- Update network denendency in daemon systemd template [\#489](https://github.com/voxpupuli/puppet-prometheus/pull/489) ([moonape1226](https://github.com/moonape1226))

**Closed issues:**

- Support for IPMI exporter [\#521](https://github.com/voxpupuli/puppet-prometheus/issues/521)
- env\_file\_path has no effect on prometheus::server [\#323](https://github.com/voxpupuli/puppet-prometheus/issues/323)

**Merged pull requests:**

- check node exporter config file instead of bird in node exporter test [\#531](https://github.com/voxpupuli/puppet-prometheus/pull/531) ([anarcat](https://github.com/anarcat))
- pass options through env\_vars if no control over init files [\#530](https://github.com/voxpupuli/puppet-prometheus/pull/530) ([anarcat](https://github.com/anarcat))
- convert daemon.env template to EPP [\#529](https://github.com/voxpupuli/puppet-prometheus/pull/529) ([anarcat](https://github.com/anarcat))
- deploy env\_file\_path on server [\#527](https://github.com/voxpupuli/puppet-prometheus/pull/527) ([anarcat](https://github.com/anarcat))
- Support for IPMI exporter [\#522](https://github.com/voxpupuli/puppet-prometheus/pull/522) ([benibr](https://github.com/benibr))

## [v11.0.0](https://github.com/voxpupuli/puppet-prometheus/tree/v11.0.0) (2021-01-18)

[Full Changelog](https://github.com/voxpupuli/puppet-prometheus/compare/v10.2.0...v11.0.0)

**Breaking changes:**

- Drop Puppet 5; require at least Puppet 6.1.0 [\#518](https://github.com/voxpupuli/puppet-prometheus/pull/518) ([bastelfreak](https://github.com/bastelfreak))
- puppetdb\_exporter: Update 1.0.0-\>1.1.0 [\#513](https://github.com/voxpupuli/puppet-prometheus/pull/513) ([bastelfreak](https://github.com/bastelfreak))
- Drop EOL CentOS 6 support [\#512](https://github.com/voxpupuli/puppet-prometheus/pull/512) ([bastelfreak](https://github.com/bastelfreak))
- Drop Debian 8 support/compatibility [\#496](https://github.com/voxpupuli/puppet-prometheus/pull/496) ([bastelfreak](https://github.com/bastelfreak))

**Implemented enhancements:**

- Support Puppet 7.x [\#515](https://github.com/voxpupuli/puppet-prometheus/pull/515) ([bastelfreak](https://github.com/bastelfreak))
- Add Ubuntu 20.04 support [\#514](https://github.com/voxpupuli/puppet-prometheus/pull/514) ([bastelfreak](https://github.com/bastelfreak))
- Daemon: create env files only if required [\#493](https://github.com/voxpupuli/puppet-prometheus/pull/493) ([bastelfreak](https://github.com/bastelfreak))

**Fixed bugs:**

- Purge collected configs based on $purge\_config\_dir [\#517](https://github.com/voxpupuli/puppet-prometheus/pull/517) ([towo](https://github.com/towo))
- \(FACT-2880\) fact: call Puppet within setcode block [\#511](https://github.com/voxpupuli/puppet-prometheus/pull/511) ([bastelfreak](https://github.com/bastelfreak))
- Allow download\_extension to be empty string [\#507](https://github.com/voxpupuli/puppet-prometheus/pull/507) ([treydock](https://github.com/treydock))
- fix sysv init scripts [\#502](https://github.com/voxpupuli/puppet-prometheus/pull/502) ([kubicgruenfeld](https://github.com/kubicgruenfeld))

**Closed issues:**

- haproxy\_exporter fails scraping when haproxy.scrape-uri contains specials characters  [\#516](https://github.com/voxpupuli/puppet-prometheus/issues/516)
- scrape\_job exported resources are ignoring custom collect dir [\#490](https://github.com/voxpupuli/puppet-prometheus/issues/490)
- config.pp does not honor $prometheus::purge\_config\_dir value [\#460](https://github.com/voxpupuli/puppet-prometheus/issues/460)
- SysV init script leaves dangling shell processes [\#293](https://github.com/voxpupuli/puppet-prometheus/issues/293)

**Merged pull requests:**

- Fix typo in init.pp docs [\#504](https://github.com/voxpupuli/puppet-prometheus/pull/504) ([genebean](https://github.com/genebean))

## [v10.2.0](https://github.com/voxpupuli/puppet-prometheus/tree/v10.2.0) (2020-09-26)

[Full Changelog](https://github.com/voxpupuli/puppet-prometheus/compare/v10.1.0...v10.2.0)

Debian 8 is EOL since a few months now. This release will be the last with official Debian 8 compatibility and support. The next release will be v11.0.0 without Debian 8 support!

**Implemented enhancements:**

- Allow filtering scrape jobs by nodes [\#488](https://github.com/voxpupuli/puppet-prometheus/pull/488) ([fbs](https://github.com/fbs))
- Add option to override `scrape_host` for exporters [\#487](https://github.com/voxpupuli/puppet-prometheus/pull/487) ([fbs](https://github.com/fbs))

**Merged pull requests:**

- Extend puppet type check for install\_method [\#492](https://github.com/voxpupuli/puppet-prometheus/pull/492) ([bastelfreak](https://github.com/bastelfreak))

## [v10.1.0](https://github.com/voxpupuli/puppet-prometheus/tree/v10.1.0) (2020-08-23)

[Full Changelog](https://github.com/voxpupuli/puppet-prometheus/compare/v10.0.0...v10.1.0)

**Implemented enhancements:**

- Add support for Google Cloud gs storage [\#485](https://github.com/voxpupuli/puppet-prometheus/pull/485) ([j0sh3rs](https://github.com/j0sh3rs))
- prometheus::dellhw\_exporter: Add scrape\_ipadress parameter [\#484](https://github.com/voxpupuli/puppet-prometheus/pull/484) ([lconsuegra](https://github.com/lconsuegra))

## [v10.0.0](https://github.com/voxpupuli/puppet-prometheus/tree/v10.0.0) (2020-08-15)

[Full Changelog](https://github.com/voxpupuli/puppet-prometheus/compare/v9.1.0...v10.0.0)

**Breaking changes:**

- update version numbers to latest releases [\#479](https://github.com/voxpupuli/puppet-prometheus/pull/479) ([antondollmaier](https://github.com/antondollmaier))

**Implemented enhancements:**

- Fixes for prometheus::dellhw\_exporter not working as is [\#480](https://github.com/voxpupuli/puppet-prometheus/pull/480) ([lconsuegra](https://github.com/lconsuegra))

**Merged pull requests:**

- Prometheus: Update 2.20.0-\>2.20.1 [\#481](https://github.com/voxpupuli/puppet-prometheus/pull/481) ([bastelfreak](https://github.com/bastelfreak))
- modulesync 3.0.0 & puppet-lint updates [\#478](https://github.com/voxpupuli/puppet-prometheus/pull/478) ([bastelfreak](https://github.com/bastelfreak))

## [v9.1.0](https://github.com/voxpupuli/puppet-prometheus/tree/v9.1.0) (2020-07-21)

[Full Changelog](https://github.com/voxpupuli/puppet-prometheus/compare/v9.0.0...v9.1.0)

**Implemented enhancements:**

- Issue 469: Add dellhw\_exporter support [\#470](https://github.com/voxpupuli/puppet-prometheus/pull/470) ([kkunkel](https://github.com/kkunkel))

**Fixed bugs:**

- Exporters: Reload service if user has changed attributes [\#474](https://github.com/voxpupuli/puppet-prometheus/pull/474) ([bastelfreak](https://github.com/bastelfreak))

**Closed issues:**

- Add support for dellhw\_exporter [\#469](https://github.com/voxpupuli/puppet-prometheus/issues/469)
- Thanos unable to write to tsdb directory [\#466](https://github.com/voxpupuli/puppet-prometheus/issues/466)

**Merged pull requests:**

- updating String to String\[1\] when '' is invalid [\#471](https://github.com/voxpupuli/puppet-prometheus/pull/471) ([kkunkel](https://github.com/kkunkel))

## [v9.0.0](https://github.com/voxpupuli/puppet-prometheus/tree/v9.0.0) (2020-06-16)

[Full Changelog](https://github.com/voxpupuli/puppet-prometheus/compare/v8.5.0...v9.0.0)

**Breaking changes:**

- Redis Exporter: Update 1.3.4-\>1.6.1 [\#461](https://github.com/voxpupuli/puppet-prometheus/pull/461) ([bastelfreak](https://github.com/bastelfreak))
- Upgrade varnish\_exporter version from 1.5 to 1.5.2 [\#457](https://github.com/voxpupuli/puppet-prometheus/pull/457) ([mcanevet](https://github.com/mcanevet))
- Update PushProx to new namespace / update version 20190708 -\> 0.1.0 [\#456](https://github.com/voxpupuli/puppet-prometheus/pull/456) ([mcanevet](https://github.com/mcanevet))
- Update rabbitmq\_exporter to version 0.29.0 [\#453](https://github.com/voxpupuli/puppet-prometheus/pull/453) ([dhoppe](https://github.com/dhoppe))
- graphite\_exporter: update 0.2.0-\>0.7.1 [\#357](https://github.com/voxpupuli/puppet-prometheus/pull/357) ([bastelfreak](https://github.com/bastelfreak))

**Implemented enhancements:**

- Implement puppetdb exporter [\#463](https://github.com/voxpupuli/puppet-prometheus/pull/463) ([bastelfreak](https://github.com/bastelfreak))
- Add memcached exporter support [\#462](https://github.com/voxpupuli/puppet-prometheus/pull/462) ([bastelfreak](https://github.com/bastelfreak))
- \(\#458\) add grok\_exporter [\#459](https://github.com/voxpupuli/puppet-prometheus/pull/459) ([kuldazbraslav](https://github.com/kuldazbraslav))

**Closed issues:**

- Feature request for grok\_exporter [\#458](https://github.com/voxpupuli/puppet-prometheus/issues/458)
- Error 500 on SERVER: Server Error: Evaluation Error: Error while evaluating a Function Call, Could not find class ::systemd  [\#257](https://github.com/voxpupuli/puppet-prometheus/issues/257)

## [v8.5.0](https://github.com/voxpupuli/puppet-prometheus/tree/v8.5.0) (2020-05-21)

[Full Changelog](https://github.com/voxpupuli/puppet-prometheus/compare/v8.4.0...v8.5.0)

**Implemented enhancements:**

- Allow hiding of prom config file [\#451](https://github.com/voxpupuli/puppet-prometheus/pull/451) ([hooten](https://github.com/hooten))
- Allow extract\_path to be modified [\#449](https://github.com/voxpupuli/puppet-prometheus/pull/449) ([treydock](https://github.com/treydock))
- Add support for Debian 10 [\#447](https://github.com/voxpupuli/puppet-prometheus/pull/447) ([dhoppe](https://github.com/dhoppe))

**Merged pull requests:**

- Fix scrape job file names to ensure job\_name is prefix [\#450](https://github.com/voxpupuli/puppet-prometheus/pull/450) ([treydock](https://github.com/treydock))

## [v8.4.0](https://github.com/voxpupuli/puppet-prometheus/tree/v8.4.0) (2020-04-17)

[Full Changelog](https://github.com/voxpupuli/puppet-prometheus/compare/v8.3.0...v8.4.0)

**Implemented enhancements:**

- Use `--scrape_uri` instead of `-scrape_uri` for apache\_exporter versions 0.8.0 and greater [\#444](https://github.com/voxpupuli/puppet-prometheus/pull/444) ([krische](https://github.com/krische))
- Support ppc64le [\#443](https://github.com/voxpupuli/puppet-prometheus/pull/443) ([treydock](https://github.com/treydock))
- add achive\_bin\_path parameter defaulting to existing value [\#438](https://github.com/voxpupuli/puppet-prometheus/pull/438) ([robmbrooks](https://github.com/robmbrooks))
- Add VZ 6/7 to metadata.json [\#436](https://github.com/voxpupuli/puppet-prometheus/pull/436) ([bastelfreak](https://github.com/bastelfreak))
- have a $service\_name parameter for all prometheus-exporters [\#430](https://github.com/voxpupuli/puppet-prometheus/pull/430) ([unki](https://github.com/unki))

**Fixed bugs:**

- have node file definitions use underscore instead of column [\#435](https://github.com/voxpupuli/puppet-prometheus/pull/435) ([ndelic0](https://github.com/ndelic0))

**Closed issues:**

- Apache Exporter 0.8.0+ uses `--` as argument prefix [\#442](https://github.com/voxpupuli/puppet-prometheus/issues/442)

**Merged pull requests:**

- Use voxpupuli-acceptance [\#441](https://github.com/voxpupuli/puppet-prometheus/pull/441) ([ekohl](https://github.com/ekohl))

## [v8.3.0](https://github.com/voxpupuli/puppet-prometheus/tree/v8.3.0) (2020-02-28)

[Full Changelog](https://github.com/voxpupuli/puppet-prometheus/compare/v8.2.1...v8.3.0)

**Implemented enhancements:**

- Add service\_name parameter to haproxy-exporter [\#428](https://github.com/voxpupuli/puppet-prometheus/pull/428) ([unki](https://github.com/unki))
- Add parameter max\_open\_files to server class [\#425](https://github.com/voxpupuli/puppet-prometheus/pull/425) ([kubicgruenfeld](https://github.com/kubicgruenfeld))
- Support reloading alertmanager rather than restarting [\#424](https://github.com/voxpupuli/puppet-prometheus/pull/424) ([treydock](https://github.com/treydock))

**Fixed bugs:**

- Fix duplicate command line options in SysV script [\#427](https://github.com/voxpupuli/puppet-prometheus/pull/427) ([lukebigum](https://github.com/lukebigum))
- Add config mode to config\_dir creation [\#397](https://github.com/voxpupuli/puppet-prometheus/pull/397) ([jpc2350](https://github.com/jpc2350))

**Merged pull requests:**

- if $purge\_config\_dir=true, force-manage config\_dir [\#426](https://github.com/voxpupuli/puppet-prometheus/pull/426) ([unki](https://github.com/unki))

## [v8.2.1](https://github.com/voxpupuli/puppet-prometheus/tree/v8.2.1) (2020-01-26)

[Full Changelog](https://github.com/voxpupuli/puppet-prometheus/compare/v8.2.0...v8.2.1)

**Fixed bugs:**

- Execute systemctl daemon-reload before restarting daemons [\#419](https://github.com/voxpupuli/puppet-prometheus/pull/419) ([treydock](https://github.com/treydock))

## [v8.2.0](https://github.com/voxpupuli/puppet-prometheus/tree/v8.2.0) (2020-01-11)

[Full Changelog](https://github.com/voxpupuli/puppet-prometheus/compare/v8.1.0...v8.2.0)

**Implemented enhancements:**

- process-exporter: Add Option to provide config as hash [\#417](https://github.com/voxpupuli/puppet-prometheus/pull/417) ([bastelfreak](https://github.com/bastelfreak))
- prometheus: harden systemd service [\#415](https://github.com/voxpupuli/puppet-prometheus/pull/415) ([bastelfreak](https://github.com/bastelfreak))
- Add `managed by puppet` header to unit file [\#414](https://github.com/voxpupuli/puppet-prometheus/pull/414) ([bastelfreak](https://github.com/bastelfreak))
- migrate prometheus service file erb-\>epp [\#413](https://github.com/voxpupuli/puppet-prometheus/pull/413) ([bastelfreak](https://github.com/bastelfreak))
- Arch Linux: Use prometheus unit file from package [\#412](https://github.com/voxpupuli/puppet-prometheus/pull/412) ([bastelfreak](https://github.com/bastelfreak))
- Prometheus: Acceptance test for 2.15.1 [\#411](https://github.com/voxpupuli/puppet-prometheus/pull/411) ([bastelfreak](https://github.com/bastelfreak))
- move more static data from hiera to module [\#409](https://github.com/voxpupuli/puppet-prometheus/pull/409) ([bastelfreak](https://github.com/bastelfreak))

**Merged pull requests:**

- Use Stdlib::Ensure::Service for $service\_ensure [\#408](https://github.com/voxpupuli/puppet-prometheus/pull/408) ([bastelfreak](https://github.com/bastelfreak))
- Migrate static data from hiera to puppet code [\#407](https://github.com/voxpupuli/puppet-prometheus/pull/407) ([bastelfreak](https://github.com/bastelfreak))

## [v8.1.0](https://github.com/voxpupuli/puppet-prometheus/tree/v8.1.0) (2019-12-18)

[Full Changelog](https://github.com/voxpupuli/puppet-prometheus/compare/v8.0.0...v8.1.0)

**Implemented enhancements:**

- Add Bird exporter [\#404](https://github.com/voxpupuli/puppet-prometheus/pull/404) ([bastelfreak](https://github.com/bastelfreak))
- Convert comments to puppet-strings [\#403](https://github.com/voxpupuli/puppet-prometheus/pull/403) ([bastelfreak](https://github.com/bastelfreak))
- make apache exporter service name customizable [\#400](https://github.com/voxpupuli/puppet-prometheus/pull/400) ([anarcat](https://github.com/anarcat))
- Add postfix exporter [\#396](https://github.com/voxpupuli/puppet-prometheus/pull/396) ([alexjfisher](https://github.com/alexjfisher))

**Merged pull requests:**

- Accept `none` as valid `init_style` [\#399](https://github.com/voxpupuli/puppet-prometheus/pull/399) ([alexjfisher](https://github.com/alexjfisher))

## [v8.0.0](https://github.com/voxpupuli/puppet-prometheus/tree/v8.0.0) (2019-11-21)

[Full Changelog](https://github.com/voxpupuli/puppet-prometheus/compare/v7.1.0...v8.0.0)

**Breaking changes:**

- Update default Prometheus version from 2.11.1 to 2.14.0 [\#392](https://github.com/voxpupuli/puppet-prometheus/pull/392) ([bastelfreak](https://github.com/bastelfreak))
- Update default redis\_exporter version to 1.3.4 [\#391](https://github.com/voxpupuli/puppet-prometheus/pull/391) ([alexjfisher](https://github.com/alexjfisher))
- drop Ubuntu 14.04 support [\#384](https://github.com/voxpupuli/puppet-prometheus/pull/384) ([bastelfreak](https://github.com/bastelfreak))

**Implemented enhancements:**

- Add `scrape_job_labels` parameter to exporters [\#388](https://github.com/voxpupuli/puppet-prometheus/pull/388) ([alexjfisher](https://github.com/alexjfisher))
- Support redis\_exporter version \>= 1.0.0 [\#387](https://github.com/voxpupuli/puppet-prometheus/pull/387) ([alexjfisher](https://github.com/alexjfisher))
- Accept `Sensitive` mysqld\_exporter `cnf_password` [\#386](https://github.com/voxpupuli/puppet-prometheus/pull/386) ([alexjfisher](https://github.com/alexjfisher))

**Fixed bugs:**

- Prometheus daemon is not restarting when command-line arguments are changed [\#382](https://github.com/voxpupuli/puppet-prometheus/issues/382)
- Fix prometheus not restarting after config changes on systemd based systems [\#390](https://github.com/voxpupuli/puppet-prometheus/pull/390) ([alexjfisher](https://github.com/alexjfisher))
- Add service restart on package change [\#376](https://github.com/voxpupuli/puppet-prometheus/pull/376) ([rwaffen](https://github.com/rwaffen))

**Closed issues:**

- mtail support? [\#381](https://github.com/voxpupuli/puppet-prometheus/issues/381)
- Puppetforge not being updated [\#320](https://github.com/voxpupuli/puppet-prometheus/issues/320)

## [v7.1.0](https://github.com/voxpupuli/puppet-prometheus/tree/v7.1.0) (2019-11-05)

[Full Changelog](https://github.com/voxpupuli/puppet-prometheus/compare/v7.0.0...v7.1.0)

**Implemented enhancements:**

- Change Prometheus port [\#52](https://github.com/voxpupuli/puppet-prometheus/issues/52)
- Addd RHEL8 support / disable timesync for docker images [\#378](https://github.com/voxpupuli/puppet-prometheus/pull/378) ([bastelfreak](https://github.com/bastelfreak))
- Add prom command line args and validation [\#377](https://github.com/voxpupuli/puppet-prometheus/pull/377) ([hooten](https://github.com/hooten))
- exporters: set /usr/bin/nologin as shell [\#372](https://github.com/voxpupuli/puppet-prometheus/pull/372) ([bastelfreak](https://github.com/bastelfreak))
- Expose env\_vars to prometheus::pushprox\_client class [\#369](https://github.com/voxpupuli/puppet-prometheus/pull/369) ([mcanevet](https://github.com/mcanevet))
- Allow s3 sources for download uris [\#368](https://github.com/voxpupuli/puppet-prometheus/pull/368) ([hooten](https://github.com/hooten))
- Make elasticsearch usable with older version [\#364](https://github.com/voxpupuli/puppet-prometheus/pull/364) ([zonArt](https://github.com/zonArt))
- Archlinux: support node\_exporter installation as package [\#362](https://github.com/voxpupuli/puppet-prometheus/pull/362) ([bastelfreak](https://github.com/bastelfreak))
- make config files readonly to daemons [\#324](https://github.com/voxpupuli/puppet-prometheus/pull/324) ([anarcat](https://github.com/anarcat))

**Fixed bugs:**

- Archlinux: Do not manage node\_exporter group/user [\#373](https://github.com/voxpupuli/puppet-prometheus/pull/373) ([bastelfreak](https://github.com/bastelfreak))
- user/group: prohibit empty strings [\#371](https://github.com/voxpupuli/puppet-prometheus/pull/371) ([bastelfreak](https://github.com/bastelfreak))
- Archlinux: set correct binary name for node\_exporter [\#365](https://github.com/voxpupuli/puppet-prometheus/pull/365) ([bastelfreak](https://github.com/bastelfreak))

**Closed issues:**

- `ensure => 'absent'` doesn't do what it should do [\#374](https://github.com/voxpupuli/puppet-prometheus/issues/374)
- Add a "config\_template" for alertmanager [\#315](https://github.com/voxpupuli/puppet-prometheus/issues/315)

**Merged pull requests:**

- Clean up acceptance spec helper [\#379](https://github.com/voxpupuli/puppet-prometheus/pull/379) ([ekohl](https://github.com/ekohl))
- fix duplicate key in data/defaults.yaml [\#360](https://github.com/voxpupuli/puppet-prometheus/pull/360) ([tkuther](https://github.com/tkuther))

## [v7.0.0](https://github.com/voxpupuli/puppet-prometheus/tree/v7.0.0) (2019-07-19)

[Full Changelog](https://github.com/voxpupuli/puppet-prometheus/compare/v6.4.0...v7.0.0)

**Breaking changes:**

- apache\_exporter: update 0.5.0-\>0.7.0 [\#358](https://github.com/voxpupuli/puppet-prometheus/pull/358) ([bastelfreak](https://github.com/bastelfreak))
- varnish\_exporter: update 1.4-\>1.5 [\#356](https://github.com/voxpupuli/puppet-prometheus/pull/356) ([bastelfreak](https://github.com/bastelfreak))
- postgres\_exporter: update 0.4.6-\>0.5.1 [\#354](https://github.com/voxpupuli/puppet-prometheus/pull/354) ([bastelfreak](https://github.com/bastelfreak))
- blackbox\_exporter: update 0.7.0-\>0.14.0 & Add acceptance tests [\#353](https://github.com/voxpupuli/puppet-prometheus/pull/353) ([bastelfreak](https://github.com/bastelfreak))
- statsd\_exporter: update 0.8.0-\>0.12.1 [\#352](https://github.com/voxpupuli/puppet-prometheus/pull/352) ([bastelfreak](https://github.com/bastelfreak))
- snmp\_exporter: Update 0.7.0-\>0.15.0 & Add acceptance tests [\#351](https://github.com/voxpupuli/puppet-prometheus/pull/351) ([bastelfreak](https://github.com/bastelfreak))
- consul\_exporter: Update 0.4.0-\>0.5.0 [\#349](https://github.com/voxpupuli/puppet-prometheus/pull/349) ([bastelfreak](https://github.com/bastelfreak))
- mysqld\_exporter: update 0.9.0-\>0.12.0 [\#348](https://github.com/voxpupuli/puppet-prometheus/pull/348) ([bastelfreak](https://github.com/bastelfreak))
- consul\_exporter: update 0.3.0-\>0.4.0 [\#344](https://github.com/voxpupuli/puppet-prometheus/pull/344) ([bastelfreak](https://github.com/bastelfreak))
- nginx\_vts\_exporter: update 0.6-\>0.10.4 & Add acceptance tests [\#342](https://github.com/voxpupuli/puppet-prometheus/pull/342) ([bastelfreak](https://github.com/bastelfreak))
- pushgateway: update 0.4.0-\>0.8.0 & enhance unit tests [\#341](https://github.com/voxpupuli/puppet-prometheus/pull/341) ([bastelfreak](https://github.com/bastelfreak))
- process\_exporter: update 0.1.0-\>0.5.0 & add acceptance tests [\#340](https://github.com/voxpupuli/puppet-prometheus/pull/340) ([bastelfreak](https://github.com/bastelfreak))
- haproxy\_exporter: update 0.9.0-\>0.10.0 [\#338](https://github.com/voxpupuli/puppet-prometheus/pull/338) ([bastelfreak](https://github.com/bastelfreak))
- mesos\_exporter: update 1.0.0-\>1.1.2 & add acceptance tests [\#337](https://github.com/voxpupuli/puppet-prometheus/pull/337) ([bastelfreak](https://github.com/bastelfreak))
- node\_exporter: update 0.16.0-\>0.18.1 [\#336](https://github.com/voxpupuli/puppet-prometheus/pull/336) ([bastelfreak](https://github.com/bastelfreak))
- alertmanager: update 0.5.1-\>0.18.0 [\#335](https://github.com/voxpupuli/puppet-prometheus/pull/335) ([bastelfreak](https://github.com/bastelfreak))
- prometheus: update 2.4.3-\>2.11.1 [\#334](https://github.com/voxpupuli/puppet-prometheus/pull/334) ([bastelfreak](https://github.com/bastelfreak))
- Feature update to newest elasticsearch exporter version: 1.0.2rc1 -\> 1.1.0rc1 [\#313](https://github.com/voxpupuli/puppet-prometheus/pull/313) ([snarlistic](https://github.com/snarlistic))
- modulesync 2.6.0 and drop Puppet 4 [\#305](https://github.com/voxpupuli/puppet-prometheus/pull/305) ([bastelfreak](https://github.com/bastelfreak))
- remove version path splitting for process exporter [\#292](https://github.com/voxpupuli/puppet-prometheus/pull/292) ([moon-hawk](https://github.com/moon-hawk))
- update haproxy exporter default to 0.9.0, fix options and allow unix … [\#280](https://github.com/voxpupuli/puppet-prometheus/pull/280) ([dynek](https://github.com/dynek))
- bump prometheus version: 1.5.2-\>2.4.3 [\#276](https://github.com/voxpupuli/puppet-prometheus/pull/276) ([bastelfreak](https://github.com/bastelfreak))
- bump node\_exporter version: 0.15.2-\>0.16.0 [\#274](https://github.com/voxpupuli/puppet-prometheus/pull/274) ([othalla](https://github.com/othalla))
- Refactor statsd\_exporter class to support version \>= 0.5.0; bump from 0.3.0-\>0.8.0 [\#271](https://github.com/voxpupuli/puppet-prometheus/pull/271) ([wiebe](https://github.com/wiebe))

**Implemented enhancements:**

- Add flag for managing the config file [\#319](https://github.com/voxpupuli/puppet-prometheus/pull/319) ([bastelfreak](https://github.com/bastelfreak))
- add ability to export/collect scrape\_jobs [\#304](https://github.com/voxpupuli/puppet-prometheus/pull/304) ([anarcat](https://github.com/anarcat))
- Add support for the aarch64 architecture [\#300](https://github.com/voxpupuli/puppet-prometheus/pull/300) ([ralimi](https://github.com/ralimi))
- Add `max_open_files` parameter for systemd systems [\#298](https://github.com/voxpupuli/puppet-prometheus/pull/298) ([alexjfisher](https://github.com/alexjfisher))
- Add custom datasource possibilities for postgres\_exporter [\#289](https://github.com/voxpupuli/puppet-prometheus/pull/289) ([romdav00](https://github.com/romdav00))
- Test with unix socket for scraping uri [\#286](https://github.com/voxpupuli/puppet-prometheus/pull/286) ([othalla](https://github.com/othalla))
- Add apache exporter support [\#284](https://github.com/voxpupuli/puppet-prometheus/pull/284) ([wiebe](https://github.com/wiebe))
- Add bin\_name override to daemon.pp [\#281](https://github.com/voxpupuli/puppet-prometheus/pull/281) ([dudemcbacon](https://github.com/dudemcbacon))
- Add MacOS support [\#279](https://github.com/voxpupuli/puppet-prometheus/pull/279) ([hatvik](https://github.com/hatvik))
- Add support for armv6 and amrv5 [\#278](https://github.com/voxpupuli/puppet-prometheus/pull/278) ([wiebe](https://github.com/wiebe))
- Validate Alertmanager config [\#277](https://github.com/voxpupuli/puppet-prometheus/pull/277) ([allangood](https://github.com/allangood))
- Allow override of extract command for archives [\#54](https://github.com/voxpupuli/puppet-prometheus/pull/54) ([atward](https://github.com/atward))

**Fixed bugs:**

- Pupppet sysv fails due to -log.format option [\#268](https://github.com/voxpupuli/puppet-prometheus/issues/268)
- pushgateway: use correct CPU architecture & add acceptance tests [\#346](https://github.com/voxpupuli/puppet-prometheus/pull/346) ([bastelfreak](https://github.com/bastelfreak))
- mesos\_exporter: add unit tests & Fix bug/typo in parameter assignment [\#339](https://github.com/voxpupuli/puppet-prometheus/pull/339) ([bastelfreak](https://github.com/bastelfreak))
- Link the amtool only if it is installed via direct download. [\#328](https://github.com/voxpupuli/puppet-prometheus/pull/328) ([sezuan](https://github.com/sezuan))
- issue \#306: Fix broken startup scripts [\#318](https://github.com/voxpupuli/puppet-prometheus/pull/318) ([bastelfreak](https://github.com/bastelfreak))
- subbing out @name in stop function with an ambiguous name. [\#314](https://github.com/voxpupuli/puppet-prometheus/pull/314) ([strings48066](https://github.com/strings48066))
- Debian daemon template: Split and escape args to avoid quotes passed as args [\#299](https://github.com/voxpupuli/puppet-prometheus/pull/299) ([ntesteca](https://github.com/ntesteca))
- fix for CentOS6 with sysv [\#290](https://github.com/voxpupuli/puppet-prometheus/pull/290) ([spali](https://github.com/spali))
- sysv, armv6/7 fixes [\#270](https://github.com/voxpupuli/puppet-prometheus/pull/270) ([defenestration](https://github.com/defenestration))

**Closed issues:**

- amtool is unconditionally linked from /opt/, even if it is installed differently. [\#327](https://github.com/voxpupuli/puppet-prometheus/issues/327)
- Next Tag ? [\#316](https://github.com/voxpupuli/puppet-prometheus/issues/316)
- Process-exporter sysv init stop process command not found [\#311](https://github.com/voxpupuli/puppet-prometheus/issues/311)
- Bad formed prometheus.service  [\#306](https://github.com/voxpupuli/puppet-prometheus/issues/306)
- apache\_exporter unable to contact apache on Debian 7 [\#296](https://github.com/voxpupuli/puppet-prometheus/issues/296)
- Unable to force arch for installing exporter [\#265](https://github.com/voxpupuli/puppet-prometheus/issues/265)
- support statsd\_exporter \>= 0.5.0 [\#248](https://github.com/voxpupuli/puppet-prometheus/issues/248)
- Service fails to start under systemd [\#244](https://github.com/voxpupuli/puppet-prometheus/issues/244)
- Add support for exporting/collecting \*\_exporter configs [\#126](https://github.com/voxpupuli/puppet-prometheus/issues/126)

**Merged pull requests:**

- Cleanup acceptance tests [\#347](https://github.com/voxpupuli/puppet-prometheus/pull/347) ([bastelfreak](https://github.com/bastelfreak))
- Archlinux: update prometheus 2.2.0-\>2.10.0 [\#345](https://github.com/voxpupuli/puppet-prometheus/pull/345) ([bastelfreak](https://github.com/bastelfreak))
- Add Pushprox client and proxy [\#333](https://github.com/voxpupuli/puppet-prometheus/pull/333) ([mcanevet](https://github.com/mcanevet))
- alertmanager - Add flag for managing the config file [\#332](https://github.com/voxpupuli/puppet-prometheus/pull/332) ([daniellawrence](https://github.com/daniellawrence))
- Make mongodb usable with newer version [\#331](https://github.com/voxpupuli/puppet-prometheus/pull/331) ([zonArt](https://github.com/zonArt))
- prohibit empty service\_provider fact [\#330](https://github.com/voxpupuli/puppet-prometheus/pull/330) ([bastelfreak](https://github.com/bastelfreak))
- Allow `puppetlabs/stdlib` 6.x and `puppet/archive` 4.x [\#321](https://github.com/voxpupuli/puppet-prometheus/pull/321) ([alexjfisher](https://github.com/alexjfisher))
- Improve the code examples in the README [\#301](https://github.com/voxpupuli/puppet-prometheus/pull/301) ([natemccurdy](https://github.com/natemccurdy))
- cleanup duplicated entries in case block [\#295](https://github.com/voxpupuli/puppet-prometheus/pull/295) ([bastelfreak](https://github.com/bastelfreak))
- Add & refactor haproxy tests for scraping uri [\#288](https://github.com/voxpupuli/puppet-prometheus/pull/288) ([othalla](https://github.com/othalla))
- Haproxy spec improvements [\#287](https://github.com/voxpupuli/puppet-prometheus/pull/287) ([othalla](https://github.com/othalla))

## [v6.4.0](https://github.com/voxpupuli/puppet-prometheus/tree/v6.4.0) (2018-10-21)

[Full Changelog](https://github.com/voxpupuli/puppet-prometheus/compare/v6.3.0...v6.4.0)

**Implemented enhancements:**

- Add armv7 support [\#273](https://github.com/voxpupuli/puppet-prometheus/pull/273) ([othalla](https://github.com/othalla))
- Feature/collectd exporter [\#272](https://github.com/voxpupuli/puppet-prometheus/pull/272) ([mindriot88](https://github.com/mindriot88))
- consul\_exporter improvement for version 0.4.0 and above [\#264](https://github.com/voxpupuli/puppet-prometheus/pull/264) ([RogierO](https://github.com/RogierO))

## [v6.3.0](https://github.com/voxpupuli/puppet-prometheus/tree/v6.3.0) (2018-10-06)

[Full Changelog](https://github.com/voxpupuli/puppet-prometheus/compare/v6.2.0...v6.3.0)

**Implemented enhancements:**

- Use more compatible STDERR/STDOUT redirection syntax in sysv init script [\#259](https://github.com/voxpupuli/puppet-prometheus/pull/259) ([tkuther](https://github.com/tkuther))
- allow puppetlabs/stdlib 5.x [\#256](https://github.com/voxpupuli/puppet-prometheus/pull/256) ([bastelfreak](https://github.com/bastelfreak))
- Add support for mysqld\_exporter version 0.11.0 [\#247](https://github.com/voxpupuli/puppet-prometheus/pull/247) ([TheMeier](https://github.com/TheMeier))

**Fixed bugs:**

- Render alerts file properly depending on prometheus version [\#253](https://github.com/voxpupuli/puppet-prometheus/pull/253) ([bastelfreak](https://github.com/bastelfreak))

**Closed issues:**

- expects a value [\#262](https://github.com/voxpupuli/puppet-prometheus/issues/262)
- prometheus::haproxy\_exporter Failing [\#261](https://github.com/voxpupuli/puppet-prometheus/issues/261)
- User needs to adjust $extra\_options for mysqld\_exporter 0.11 and newer [\#255](https://github.com/voxpupuli/puppet-prometheus/issues/255)
- Error when installing Prometheus server [\#252](https://github.com/voxpupuli/puppet-prometheus/issues/252)

**Merged pull requests:**

- modulesync 2.1.0 and allow puppet 6.x [\#266](https://github.com/voxpupuli/puppet-prometheus/pull/266) ([bastelfreak](https://github.com/bastelfreak))
- Fix misleading example of hieradata usage in blackbox\_exporter [\#250](https://github.com/voxpupuli/puppet-prometheus/pull/250) ([bramblek1](https://github.com/bramblek1))

## [v6.2.0](https://github.com/voxpupuli/puppet-prometheus/tree/v6.2.0) (2018-08-02)

[Full Changelog](https://github.com/voxpupuli/puppet-prometheus/compare/v6.1.0...v6.2.0)

**Implemented enhancements:**

- add postgres exporter [\#236](https://github.com/voxpupuli/puppet-prometheus/pull/236) ([blupman](https://github.com/blupman))
- add ubuntu 18.04 support [\#235](https://github.com/voxpupuli/puppet-prometheus/pull/235) ([bastelfreak](https://github.com/bastelfreak))

**Fixed bugs:**

- $rule\_files parameter not respected  [\#180](https://github.com/voxpupuli/puppet-prometheus/issues/180)
- enhance acceptance tests / dont quote web.external-url param [\#245](https://github.com/voxpupuli/puppet-prometheus/pull/245) ([bastelfreak](https://github.com/bastelfreak))
- 180 rule files param [\#241](https://github.com/voxpupuli/puppet-prometheus/pull/241) ([bramblek1](https://github.com/bramblek1))

**Merged pull requests:**

- extra spec tests for redis\_exporter [\#237](https://github.com/voxpupuli/puppet-prometheus/pull/237) ([blupman](https://github.com/blupman))

## [v6.1.0](https://github.com/voxpupuli/puppet-prometheus/tree/v6.1.0) (2018-07-29)

[Full Changelog](https://github.com/voxpupuli/puppet-prometheus/compare/v6.0.6...v6.1.0)

**Implemented enhancements:**

- use web.external-url configuration [\#233](https://github.com/voxpupuli/puppet-prometheus/pull/233) ([tuxmea](https://github.com/tuxmea))

**Fixed bugs:**

- Debian init script for prometheus daemon doesn't implement 'reload'  [\#240](https://github.com/voxpupuli/puppet-prometheus/issues/240)

**Closed issues:**

- web.external-url [\#232](https://github.com/voxpupuli/puppet-prometheus/issues/232)

**Merged pull requests:**

- revert eff8dad2 - dont update bundler during travis runs [\#239](https://github.com/voxpupuli/puppet-prometheus/pull/239) ([bastelfreak](https://github.com/bastelfreak))

## [v6.0.6](https://github.com/voxpupuli/puppet-prometheus/tree/v6.0.6) (2018-07-04)

[Full Changelog](https://github.com/voxpupuli/puppet-prometheus/compare/v6.0.5...v6.0.6)

**Fixed bugs:**

- Redirect SDTERR to SDTOUT for logfile [\#223](https://github.com/voxpupuli/puppet-prometheus/pull/223) ([mkrakowitzer](https://github.com/mkrakowitzer))
- fix notify $service\_name in the alertmanager [\#222](https://github.com/voxpupuli/puppet-prometheus/pull/222) ([thde](https://github.com/thde))

**Closed issues:**

- haproxy\_exporter New flag handling \> 0.8 [\#227](https://github.com/voxpupuli/puppet-prometheus/issues/227)

## [v6.0.5](https://github.com/voxpupuli/puppet-prometheus/tree/v6.0.5) (2018-06-23)

[Full Changelog](https://github.com/voxpupuli/puppet-prometheus/compare/v6.0.4...v6.0.5)

**Fixed bugs:**

- The real\_download\_url in process-exporter manifest doesn't match to newer versions [\#212](https://github.com/voxpupuli/puppet-prometheus/issues/212)
- fix support for process\_exporter 0.2.0 and newer [\#220](https://github.com/voxpupuli/puppet-prometheus/pull/220) ([tuxmea](https://github.com/tuxmea))

## [v6.0.4](https://github.com/voxpupuli/puppet-prometheus/tree/v6.0.4) (2018-06-21)

[Full Changelog](https://github.com/voxpupuli/puppet-prometheus/compare/v6.0.3...v6.0.4)

**Merged pull requests:**

- bump archive upper version boundary to \<4.0.0 [\#218](https://github.com/voxpupuli/puppet-prometheus/pull/218) ([bastelfreak](https://github.com/bastelfreak))

## [v6.0.3](https://github.com/voxpupuli/puppet-prometheus/tree/v6.0.3) (2018-06-21)

[Full Changelog](https://github.com/voxpupuli/puppet-prometheus/compare/v6.0.2...v6.0.3)

**Fixed bugs:**

- use service name for redis\_exporter to prevent multiple downloads of redis\_exporter [\#216](https://github.com/voxpupuli/puppet-prometheus/pull/216) ([blupman](https://github.com/blupman))

**Closed issues:**

- redis\_exporter is downloaded every puppet run [\#215](https://github.com/voxpupuli/puppet-prometheus/issues/215)

## [v6.0.2](https://github.com/voxpupuli/puppet-prometheus/tree/v6.0.2) (2018-06-19)

[Full Changelog](https://github.com/voxpupuli/puppet-prometheus/compare/v6.0.1...v6.0.2)

**Fixed bugs:**

- Remove double quotes from source\_labels value with gsub [\#213](https://github.com/voxpupuli/puppet-prometheus/pull/213) ([sebastianrakel](https://github.com/sebastianrakel))

## [v6.0.1](https://github.com/voxpupuli/puppet-prometheus/tree/v6.0.1) (2018-06-12)

[Full Changelog](https://github.com/voxpupuli/puppet-prometheus/compare/v6.0.0...v6.0.1)

**Fixed bugs:**

- Prometheus service wont run if installed from package [\#62](https://github.com/voxpupuli/puppet-prometheus/issues/62)
- start-stop scripts get vars from prometheus::server scope [\#210](https://github.com/voxpupuli/puppet-prometheus/pull/210) ([edevreede](https://github.com/edevreede))
- use lookup instead of puppet variable in data [\#209](https://github.com/voxpupuli/puppet-prometheus/pull/209) ([tuxmea](https://github.com/tuxmea))
- upgrade stdlib dependancy to minium 4.25.0 [\#207](https://github.com/voxpupuli/puppet-prometheus/pull/207) ([blupman](https://github.com/blupman))

**Closed issues:**

- stdlib dependancy should be updated to 4.25 [\#206](https://github.com/voxpupuli/puppet-prometheus/issues/206)

## [v6.0.0](https://github.com/voxpupuli/puppet-prometheus/tree/v6.0.0) (2018-06-01)

[Full Changelog](https://github.com/voxpupuli/puppet-prometheus/compare/v5.0.0...v6.0.0)

**Breaking changes:**

- Install prometheus server via own class [\#194](https://github.com/voxpupuli/puppet-prometheus/pull/194) ([bastelfreak](https://github.com/bastelfreak))

**Implemented enhancements:**

- allow to set prometheus server config filename [\#200](https://github.com/voxpupuli/puppet-prometheus/pull/200) ([bastelfreak](https://github.com/bastelfreak))
- Add Graphite exporter [\#191](https://github.com/voxpupuli/puppet-prometheus/pull/191) ([bastelfreak](https://github.com/bastelfreak))
- Convert to data-in-modules [\#178](https://github.com/voxpupuli/puppet-prometheus/pull/178) ([bastelfreak](https://github.com/bastelfreak))
- Add Debian 9 support [\#176](https://github.com/voxpupuli/puppet-prometheus/pull/176) ([bastelfreak](https://github.com/bastelfreak))
- Add Datatypes to all parameters [\#175](https://github.com/voxpupuli/puppet-prometheus/pull/175) ([bastelfreak](https://github.com/bastelfreak))
- simplify init handling with service\_provider fact [\#173](https://github.com/voxpupuli/puppet-prometheus/pull/173) ([bastelfreak](https://github.com/bastelfreak))
- Add Archlinux support [\#172](https://github.com/voxpupuli/puppet-prometheus/pull/172) ([bastelfreak](https://github.com/bastelfreak))
- add varnish\_exporter [\#171](https://github.com/voxpupuli/puppet-prometheus/pull/171) ([blupman](https://github.com/blupman))

**Fixed bugs:**

- Wrong installation method on archlinux [\#195](https://github.com/voxpupuli/puppet-prometheus/issues/195)
- Wrong architecture used on CentOS 64bit for exporters [\#192](https://github.com/voxpupuli/puppet-prometheus/issues/192)
- fix hiera key {prometheus\_,}install\_method on arch [\#196](https://github.com/voxpupuli/puppet-prometheus/pull/196) ([bastelfreak](https://github.com/bastelfreak))
- use correct architecture variable from init.pp in exporters [\#193](https://github.com/voxpupuli/puppet-prometheus/pull/193) ([bastelfreak](https://github.com/bastelfreak))
- change default inhibit\_rules to reflect previous params.pp config [\#181](https://github.com/voxpupuli/puppet-prometheus/pull/181) ([blupman](https://github.com/blupman))

**Closed issues:**

- node\_exporterd defaults to older version [\#188](https://github.com/voxpupuli/puppet-prometheus/issues/188)
- node exporter also installs prometheus server on monitored node [\#184](https://github.com/voxpupuli/puppet-prometheus/issues/184)
- alertmanager default inhibit\_rules error [\#182](https://github.com/voxpupuli/puppet-prometheus/issues/182)

**Merged pull requests:**

- Update node\_exporter default version 0.14.0 -\> 0.15.2 [\#204](https://github.com/voxpupuli/puppet-prometheus/pull/204) ([blupman](https://github.com/blupman))
- migrate more default values to hiera [\#201](https://github.com/voxpupuli/puppet-prometheus/pull/201) ([bastelfreak](https://github.com/bastelfreak))
- dont use single class reference in an array [\#199](https://github.com/voxpupuli/puppet-prometheus/pull/199) ([bastelfreak](https://github.com/bastelfreak))
- fix typos in the README.md [\#198](https://github.com/voxpupuli/puppet-prometheus/pull/198) ([bastelfreak](https://github.com/bastelfreak))
- migrate server related classes to private scope [\#197](https://github.com/voxpupuli/puppet-prometheus/pull/197) ([bastelfreak](https://github.com/bastelfreak))
- Rely on beaker-hostgenerator for docker nodesets [\#190](https://github.com/voxpupuli/puppet-prometheus/pull/190) ([ekohl](https://github.com/ekohl))
- switch from topscope to class scope for variables [\#189](https://github.com/voxpupuli/puppet-prometheus/pull/189) ([bastelfreak](https://github.com/bastelfreak))
- extend README.md [\#177](https://github.com/voxpupuli/puppet-prometheus/pull/177) ([bastelfreak](https://github.com/bastelfreak))
- drop legacy debian 7 [\#174](https://github.com/voxpupuli/puppet-prometheus/pull/174) ([bastelfreak](https://github.com/bastelfreak))
- allow camptocamp/systemd 2.X [\#170](https://github.com/voxpupuli/puppet-prometheus/pull/170) ([bastelfreak](https://github.com/bastelfreak))

## [v5.0.0](https://github.com/voxpupuli/puppet-prometheus/tree/v5.0.0) (2018-02-26)

[Full Changelog](https://github.com/voxpupuli/puppet-prometheus/compare/v4.1.1...v5.0.0)

**Breaking changes:**

- Feature/multiple rules files [\#166](https://github.com/voxpupuli/puppet-prometheus/pull/166) ([zipkid](https://github.com/zipkid))

**Merged pull requests:**

- Fix small typo in hiera example [\#164](https://github.com/voxpupuli/puppet-prometheus/pull/164) ([bearnard](https://github.com/bearnard))

## [v4.1.1](https://github.com/voxpupuli/puppet-prometheus/tree/v4.1.1) (2018-02-18)

[Full Changelog](https://github.com/voxpupuli/puppet-prometheus/compare/v4.1.0...v4.1.1)

**Fixed bugs:**

- puppetlabs/stdlib dependency appears to be 4.20.0 and not 4.13.1  [\#161](https://github.com/voxpupuli/puppet-prometheus/issues/161)
- raise stdlib version dependency [\#162](https://github.com/voxpupuli/puppet-prometheus/pull/162) ([tuxmea](https://github.com/tuxmea))

**Merged pull requests:**

- release 4.1.1 [\#163](https://github.com/voxpupuli/puppet-prometheus/pull/163) ([bastelfreak](https://github.com/bastelfreak))

## [v4.1.0](https://github.com/voxpupuli/puppet-prometheus/tree/v4.1.0) (2018-02-14)

[Full Changelog](https://github.com/voxpupuli/puppet-prometheus/compare/v4.0.0...v4.1.0)

**Implemented enhancements:**

- Add support for rabbitmq\_exporter [\#149](https://github.com/voxpupuli/puppet-prometheus/issues/149)
- Added redis\_exporter module [\#157](https://github.com/voxpupuli/puppet-prometheus/pull/157) ([yackushevas](https://github.com/yackushevas))
- Add rabbitmq exporter [\#153](https://github.com/voxpupuli/puppet-prometheus/pull/153) ([costela](https://github.com/costela))
- add envvars support to daemon [\#151](https://github.com/voxpupuli/puppet-prometheus/pull/151) ([costela](https://github.com/costela))
- adding remote\_write support [\#144](https://github.com/voxpupuli/puppet-prometheus/pull/144) ([gangsta](https://github.com/gangsta))

**Fixed bugs:**

- Alert rule validation error [\#143](https://github.com/voxpupuli/puppet-prometheus/issues/143)
- Facter error on older distributions \(Ubuntu Trusty\) [\#142](https://github.com/voxpupuli/puppet-prometheus/issues/142)
- bug: alert rules are still 1.0 syntax for Prometheus 2 [\#120](https://github.com/voxpupuli/puppet-prometheus/issues/120)
- \[minor\] change default alerts to empty hash [\#152](https://github.com/voxpupuli/puppet-prometheus/pull/152) ([costela](https://github.com/costela))

**Closed issues:**

- Add ability to set environment variables for daemons [\#150](https://github.com/voxpupuli/puppet-prometheus/issues/150)

**Merged pull requests:**

- release 4.1.0 [\#159](https://github.com/voxpupuli/puppet-prometheus/pull/159) ([bastelfreak](https://github.com/bastelfreak))
- update blackbox\_exporter.pp inline documentation [\#155](https://github.com/voxpupuli/puppet-prometheus/pull/155) ([ghost](https://github.com/ghost))
- Ruby 1.8 compatibility \(Agent-side\) [\#146](https://github.com/voxpupuli/puppet-prometheus/pull/146) ([sathieu](https://github.com/sathieu))
- Fail silently when service is not installed [\#145](https://github.com/voxpupuli/puppet-prometheus/pull/145) ([vladgh](https://github.com/vladgh))
- Add support for snmp\_exporter [\#125](https://github.com/voxpupuli/puppet-prometheus/pull/125) ([sathieu](https://github.com/sathieu))
- new feature - consul\_exporter [\#36](https://github.com/voxpupuli/puppet-prometheus/pull/36) ([pavloos](https://github.com/pavloos))

## [v4.0.0](https://github.com/voxpupuli/puppet-prometheus/tree/v4.0.0) (2018-01-04)

[Full Changelog](https://github.com/voxpupuli/puppet-prometheus/compare/v3.1.0...v4.0.0)

**Breaking changes:**

- Bump dependencies [\#124](https://github.com/voxpupuli/puppet-prometheus/pull/124) ([juniorsysadmin](https://github.com/juniorsysadmin))
- Add validation to config changes [\#122](https://github.com/voxpupuli/puppet-prometheus/pull/122) ([costela](https://github.com/costela))

**Implemented enhancements:**

- Install Promtool [\#31](https://github.com/voxpupuli/puppet-prometheus/issues/31)
- add explicit parameter for retention [\#137](https://github.com/voxpupuli/puppet-prometheus/pull/137) ([costela](https://github.com/costela))
- Feature/alerts prometheus2 [\#127](https://github.com/voxpupuli/puppet-prometheus/pull/127) ([jhooyberghs](https://github.com/jhooyberghs))

**Fixed bugs:**

- not up to date dependencies: puppetlabs-stdlib should be \>= 4.13.0 [\#123](https://github.com/voxpupuli/puppet-prometheus/issues/123)
- prometheus systemd wants and depends "multi-user.target" [\#139](https://github.com/voxpupuli/puppet-prometheus/pull/139) ([bastelfreak](https://github.com/bastelfreak))
- daemon: explicitly pass provider to service [\#133](https://github.com/voxpupuli/puppet-prometheus/pull/133) ([costela](https://github.com/costela))

**Closed issues:**

- Minor: add explicit retention option? [\#136](https://github.com/voxpupuli/puppet-prometheus/issues/136)
- node\_exporter: "Could not find init script for node\_exporter" [\#132](https://github.com/voxpupuli/puppet-prometheus/issues/132)
- Usage of `puppet` in custom alertmanager fact breaks if puppet not in $PATH \(e.g. systemd service\) [\#130](https://github.com/voxpupuli/puppet-prometheus/issues/130)

**Merged pull requests:**

- Use puppet internals to determine the state of the alert\_manager [\#131](https://github.com/voxpupuli/puppet-prometheus/pull/131) ([vStone](https://github.com/vStone))
- Correct typo in documentation header for node\_exporter [\#121](https://github.com/voxpupuli/puppet-prometheus/pull/121) ([jhooyberghs](https://github.com/jhooyberghs))

## [v3.1.0](https://github.com/voxpupuli/puppet-prometheus/tree/v3.1.0) (2017-11-26)

[Full Changelog](https://github.com/voxpupuli/puppet-prometheus/compare/v3.0.0...v3.1.0)

**Implemented enhancements:**

- add support for remote\_read [\#109](https://github.com/voxpupuli/puppet-prometheus/pull/109) ([lobeck](https://github.com/lobeck))
- messagebird/beanstalkd\_exporter support [\#105](https://github.com/voxpupuli/puppet-prometheus/pull/105) ([TomaszUrugOlszewski](https://github.com/TomaszUrugOlszewski))
- Add support for mesos exporter [\#59](https://github.com/voxpupuli/puppet-prometheus/pull/59) ([tahaalibra](https://github.com/tahaalibra))

**Fixed bugs:**

- Unable to use this module on fresh alert manager instances [\#55](https://github.com/voxpupuli/puppet-prometheus/issues/55)
- older versions of puppet don't know about the --to\_yaml option [\#119](https://github.com/voxpupuli/puppet-prometheus/pull/119) ([tuxmea](https://github.com/tuxmea))
- prometheus systemd needs network-online and started after multi-user. [\#117](https://github.com/voxpupuli/puppet-prometheus/pull/117) ([tuxmea](https://github.com/tuxmea))
- Disable line wrapping when converting full\_config to yaml.  [\#104](https://github.com/voxpupuli/puppet-prometheus/pull/104) ([benpollardcts](https://github.com/benpollardcts))
- verify whether alert\_manager is running [\#101](https://github.com/voxpupuli/puppet-prometheus/pull/101) ([tuxmea](https://github.com/tuxmea))

**Closed issues:**

- Error: Could not parse application options: invalid option: --to\_yaml [\#118](https://github.com/voxpupuli/puppet-prometheus/issues/118)
- Flaky Acceptance Tests in TravisCI [\#114](https://github.com/voxpupuli/puppet-prometheus/issues/114)
- Update release on forge.puppetlabs.com [\#107](https://github.com/voxpupuli/puppet-prometheus/issues/107)

**Merged pull requests:**

- replace all Variant\[Undef.. with Optional\[... [\#103](https://github.com/voxpupuli/puppet-prometheus/pull/103) ([TheMeier](https://github.com/TheMeier))
- Tests for prometheus::daemon [\#87](https://github.com/voxpupuli/puppet-prometheus/pull/87) ([sathieu](https://github.com/sathieu))

## [v3.0.0](https://github.com/voxpupuli/puppet-prometheus/tree/v3.0.0) (2017-10-31)

[Full Changelog](https://github.com/voxpupuli/puppet-prometheus/compare/v2.0.0...v3.0.0)

**Breaking changes:**

- node\_exporter 0.15.0 compatibiity [\#72](https://github.com/voxpupuli/puppet-prometheus/pull/72) ([TheMeier](https://github.com/TheMeier))

**Implemented enhancements:**

- Running puppet restarts service [\#37](https://github.com/voxpupuli/puppet-prometheus/issues/37)
- manage systemd unit files with camptocamp/systemd [\#90](https://github.com/voxpupuli/puppet-prometheus/pull/90) ([bastelfreak](https://github.com/bastelfreak))
- add basic acceptance tests; fix wrong service handling in Ubuntu 14.04 [\#86](https://github.com/voxpupuli/puppet-prometheus/pull/86) ([bastelfreak](https://github.com/bastelfreak))
- Fix restart\_on\_change and add tests to Class\[prometheus\] [\#83](https://github.com/voxpupuli/puppet-prometheus/pull/83) ([sathieu](https://github.com/sathieu))
- add feature blackbox exporter [\#74](https://github.com/voxpupuli/puppet-prometheus/pull/74) ([bramblek1](https://github.com/bramblek1))
- Add nginx-vts-exporter [\#71](https://github.com/voxpupuli/puppet-prometheus/pull/71) ([viq](https://github.com/viq))
- Add pushgateway [\#68](https://github.com/voxpupuli/puppet-prometheus/pull/68) ([mdebruyn-trip](https://github.com/mdebruyn-trip))
- Support prometheus \>= 2.0 [\#48](https://github.com/voxpupuli/puppet-prometheus/pull/48) ([sathieu](https://github.com/sathieu))

**Fixed bugs:**

- Blackbox\_exporter manifest erroneously uses -config.file instead of --config.file parameter [\#96](https://github.com/voxpupuli/puppet-prometheus/issues/96)
- Service resource in `prometheus::daemon` does not depend on `init_style` dependent service description [\#94](https://github.com/voxpupuli/puppet-prometheus/issues/94)
- Wrong service reload command on ubuntu 14.04 [\#89](https://github.com/voxpupuli/puppet-prometheus/issues/89)
- blackbox exporters source\_labels must be unquoted [\#98](https://github.com/voxpupuli/puppet-prometheus/pull/98) ([tuxmea](https://github.com/tuxmea))
- add service notification to systemd and sysv [\#95](https://github.com/voxpupuli/puppet-prometheus/pull/95) ([tuxmea](https://github.com/tuxmea))
- Fix isssue with node\_exporter containing empty pid on RHEL6. [\#88](https://github.com/voxpupuli/puppet-prometheus/pull/88) ([mkrakowitzer](https://github.com/mkrakowitzer))

**Closed issues:**

- node\_expoerter v0.15.0 [\#70](https://github.com/voxpupuli/puppet-prometheus/issues/70)
- Tag 1.0.0 [\#47](https://github.com/voxpupuli/puppet-prometheus/issues/47)
- Default Node Exporter Collectors [\#33](https://github.com/voxpupuli/puppet-prometheus/issues/33)
- Minor nitpick [\#1](https://github.com/voxpupuli/puppet-prometheus/issues/1)

**Merged pull requests:**

- use double dash for blackbox exporter options [\#97](https://github.com/voxpupuli/puppet-prometheus/pull/97) ([tuxmea](https://github.com/tuxmea))
- Improve readability of README [\#93](https://github.com/voxpupuli/puppet-prometheus/pull/93) ([roidelapluie](https://github.com/roidelapluie))
- Switch systemd restart from always to on-failure [\#92](https://github.com/voxpupuli/puppet-prometheus/pull/92) ([bastelfreak](https://github.com/bastelfreak))
- Alertmanager global config should be a hash not an array [\#91](https://github.com/voxpupuli/puppet-prometheus/pull/91) ([attachmentgenie](https://github.com/attachmentgenie))
- Test content params of File resources in Class\[prometheus\] [\#84](https://github.com/voxpupuli/puppet-prometheus/pull/84) ([sathieu](https://github.com/sathieu))
- drop legacy validate\_bool calls [\#82](https://github.com/voxpupuli/puppet-prometheus/pull/82) ([bastelfreak](https://github.com/bastelfreak))
- replace validate\_\* with datatypes in statsd\_exporter [\#81](https://github.com/voxpupuli/puppet-prometheus/pull/81) ([bastelfreak](https://github.com/bastelfreak))
- bump puppet version dependency to at least 4.7.1 [\#80](https://github.com/voxpupuli/puppet-prometheus/pull/80) ([bastelfreak](https://github.com/bastelfreak))
- replace validate\_\* with datatypes in mysqld\_exporter [\#79](https://github.com/voxpupuli/puppet-prometheus/pull/79) ([bastelfreak](https://github.com/bastelfreak))
- replace validate\_\* with datatypes in process\_exporter [\#78](https://github.com/voxpupuli/puppet-prometheus/pull/78) ([bastelfreak](https://github.com/bastelfreak))
- replace validate\_\* with datatypes in haproxy\_exporter [\#77](https://github.com/voxpupuli/puppet-prometheus/pull/77) ([bastelfreak](https://github.com/bastelfreak))
- replace validate\_\* with datatypes in alertmanager [\#76](https://github.com/voxpupuli/puppet-prometheus/pull/76) ([bastelfreak](https://github.com/bastelfreak))
- replace validate\_\* with datatypes in init [\#75](https://github.com/voxpupuli/puppet-prometheus/pull/75) ([bastelfreak](https://github.com/bastelfreak))
- use Optional instead of Variant\[Undef... [\#73](https://github.com/voxpupuli/puppet-prometheus/pull/73) ([TheMeier](https://github.com/TheMeier))

## [v2.0.0](https://github.com/voxpupuli/puppet-prometheus/tree/v2.0.0) (2017-10-12)

[Full Changelog](https://github.com/voxpupuli/puppet-prometheus/compare/1.0.0...v2.0.0)

**Breaking changes:**

- release 2.0.0 [\#66](https://github.com/voxpupuli/puppet-prometheus/pull/66) ([bastelfreak](https://github.com/bastelfreak))
- Add elasticsearch exporter. Drop Puppet 3 support. [\#51](https://github.com/voxpupuli/puppet-prometheus/pull/51) ([rbestbmj](https://github.com/rbestbmj))

**Implemented enhancements:**

- Bump versions for archive and puppet dependency/support puppet5 [\#65](https://github.com/voxpupuli/puppet-prometheus/pull/65) ([bastelfreak](https://github.com/bastelfreak))
- Add tests for elasticsearch\_exporter and update a bit [\#64](https://github.com/voxpupuli/puppet-prometheus/pull/64) ([salekseev](https://github.com/salekseev))
- Allow uncompressed daemons [\#53](https://github.com/voxpupuli/puppet-prometheus/pull/53) ([sathieu](https://github.com/sathieu))
- Add mongodb\_exporter [\#46](https://github.com/voxpupuli/puppet-prometheus/pull/46) ([salekseev](https://github.com/salekseev))

**Fixed bugs:**

- $DAEMON info is only available for the prometheus daemon [\#50](https://github.com/voxpupuli/puppet-prometheus/pull/50) ([sathieu](https://github.com/sathieu))

**Closed issues:**

- Upgrade to Puppet4? [\#34](https://github.com/voxpupuli/puppet-prometheus/issues/34)

**Merged pull requests:**

- Remove systemd module dependency and fix missing path for a exec [\#58](https://github.com/voxpupuli/puppet-prometheus/pull/58) ([juliantaylor](https://github.com/juliantaylor))
- Update README.md [\#56](https://github.com/voxpupuli/puppet-prometheus/pull/56) ([steinbrueckri](https://github.com/steinbrueckri))
- Use default collectors if "collectors" param is empty [\#49](https://github.com/voxpupuli/puppet-prometheus/pull/49) ([sathieu](https://github.com/sathieu))
- Feature/cleanup and document [\#44](https://github.com/voxpupuli/puppet-prometheus/pull/44) ([jhooyberghs](https://github.com/jhooyberghs))
- Reload config [\#43](https://github.com/voxpupuli/puppet-prometheus/pull/43) ([vide](https://github.com/vide))
- Add param service\_name to node\_exporter class [\#40](https://github.com/voxpupuli/puppet-prometheus/pull/40) ([bastelfreak](https://github.com/bastelfreak))
- backport changes to upstream [\#39](https://github.com/voxpupuli/puppet-prometheus/pull/39) ([bastelfreak](https://github.com/bastelfreak))

## [1.0.0](https://github.com/voxpupuli/puppet-prometheus/tree/1.0.0) (2017-03-26)

[Full Changelog](https://github.com/voxpupuli/puppet-prometheus/compare/v1.0.0...1.0.0)

## [v1.0.0](https://github.com/voxpupuli/puppet-prometheus/tree/v1.0.0) (2017-03-26)

[Full Changelog](https://github.com/voxpupuli/puppet-prometheus/compare/v0.2.4...v1.0.0)

## [v0.2.4](https://github.com/voxpupuli/puppet-prometheus/tree/v0.2.4) (2017-03-13)

[Full Changelog](https://github.com/voxpupuli/puppet-prometheus/compare/v0.2.3...v0.2.4)

## [v0.2.3](https://github.com/voxpupuli/puppet-prometheus/tree/v0.2.3) (2017-03-12)

[Full Changelog](https://github.com/voxpupuli/puppet-prometheus/compare/v0.2.1...v0.2.3)

## [v0.2.1](https://github.com/voxpupuli/puppet-prometheus/tree/v0.2.1) (2017-02-04)

[Full Changelog](https://github.com/voxpupuli/puppet-prometheus/compare/v0.2.2...v0.2.1)

## [v0.2.2](https://github.com/voxpupuli/puppet-prometheus/tree/v0.2.2) (2017-01-31)

[Full Changelog](https://github.com/voxpupuli/puppet-prometheus/compare/v0.2.0...v0.2.2)

**Closed issues:**

- alertmanager systemd service doesnt start [\#28](https://github.com/voxpupuli/puppet-prometheus/issues/28)

**Merged pull requests:**

- node-exporter have a 'v' in the release name since 0.13.0 [\#29](https://github.com/voxpupuli/puppet-prometheus/pull/29) ([NairolfL](https://github.com/NairolfL))

## [v0.2.0](https://github.com/voxpupuli/puppet-prometheus/tree/v0.2.0) (2016-12-27)

[Full Changelog](https://github.com/voxpupuli/puppet-prometheus/compare/v0.1.14...v0.2.0)

**Closed issues:**

- Allow to configure scrape options by file [\#17](https://github.com/voxpupuli/puppet-prometheus/issues/17)
- Generate tag. [\#12](https://github.com/voxpupuli/puppet-prometheus/issues/12)
- Extend Readme [\#7](https://github.com/voxpupuli/puppet-prometheus/issues/7)
- Prometheus Rule Files [\#6](https://github.com/voxpupuli/puppet-prometheus/issues/6)
- Prometheus Logging to file [\#5](https://github.com/voxpupuli/puppet-prometheus/issues/5)

**Merged pull requests:**

- Add Statsd Exporter, Mysqld Exporter, make exporters generic [\#27](https://github.com/voxpupuli/puppet-prometheus/pull/27) ([lswith](https://github.com/lswith))
- adding class to create alerts [\#24](https://github.com/voxpupuli/puppet-prometheus/pull/24) ([snubba](https://github.com/snubba))

## [v0.1.14](https://github.com/voxpupuli/puppet-prometheus/tree/v0.1.14) (2016-11-11)

[Full Changelog](https://github.com/voxpupuli/puppet-prometheus/compare/v0.1.13...v0.1.14)

**Closed issues:**

- Issue when install prometheus and alertmanager  [\#23](https://github.com/voxpupuli/puppet-prometheus/issues/23)

**Merged pull requests:**

- allow specification of a custom template [\#25](https://github.com/voxpupuli/puppet-prometheus/pull/25) ([lobeck](https://github.com/lobeck))
- Allow overriding shared\_dir [\#22](https://github.com/voxpupuli/puppet-prometheus/pull/22) ([roidelapluie](https://github.com/roidelapluie))
- Remove extra blank spaces at the end of lines [\#21](https://github.com/voxpupuli/puppet-prometheus/pull/21) ([roidelapluie](https://github.com/roidelapluie))
- Fix AlertManager Class [\#20](https://github.com/voxpupuli/puppet-prometheus/pull/20) ([lswith](https://github.com/lswith))

## [v0.1.13](https://github.com/voxpupuli/puppet-prometheus/tree/v0.1.13) (2016-09-14)

[Full Changelog](https://github.com/voxpupuli/puppet-prometheus/compare/0305571d72f27fee2c494792cb0970a5d37887f7...v0.1.13)

**Closed issues:**

- Update forge version [\#10](https://github.com/voxpupuli/puppet-prometheus/issues/10)

**Merged pull requests:**

- Add console support [\#15](https://github.com/voxpupuli/puppet-prometheus/pull/15) ([mspaulding06](https://github.com/mspaulding06))
- Add missing quotes to params file [\#14](https://github.com/voxpupuli/puppet-prometheus/pull/14) ([mspaulding06](https://github.com/mspaulding06))
- Get rid of leading whitespace in generated configs [\#13](https://github.com/voxpupuli/puppet-prometheus/pull/13) ([mspaulding06](https://github.com/mspaulding06))
- Bunch of changes to work against the latest prom releases [\#11](https://github.com/voxpupuli/puppet-prometheus/pull/11) ([brutus333](https://github.com/brutus333))
- add support for newer releases of node\_exporter [\#4](https://github.com/voxpupuli/puppet-prometheus/pull/4) ([patdowney](https://github.com/patdowney))
- Systemd does not see all shutdowns as failures [\#3](https://github.com/voxpupuli/puppet-prometheus/pull/3) ([tarjei](https://github.com/tarjei))



\* *This Changelog was automatically generated by [github_changelog_generator](https://github.com/github-changelog-generator/github-changelog-generator)*
