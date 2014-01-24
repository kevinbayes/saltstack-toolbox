# Copyright 2013 Bayes Technologies
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

unzip:
  pkg:
    - installed

/opt/vertx/current/newrelic_agent3.2.2.zip:
  file:
    - managed
    - user: root
    - group: root
    - mode: 777
    - source: salt://vertx/files/newrelic_agent3.2.2.zip
    - require:
      - cmd: Create service symbolic link

Unzip newrelic:
  cmd.run:
    - name: unzip newrelic_agent3.2.2.zip -d /opt/vertx/current
    - cwd: /opt/vertx/current
    - onlyif: if [ -d "/opt/vertx/current/newrelic" ]; then false; else true; fi
    - require:
      - pkg: unzip

Change jar execution rights:
  cmd.run:
    - name: chmod uog+x *
    - cwd: /opt/vertx/current
    - require:
      - cmd: Unzip newrelic

/opt/vertx/current/newrelic/newrelic.yml:
  file:
    - managed
    - user: root
    - group: root
    - mode: 777
    - source: salt://vertx/files/newrelic.yml
    - require:
      - cmd: Unzip newrelic

Add agent to JVM_OPTS:
  cmd.run:
    - name: sed 's/^JVM_OPTS=\"/JVM_OPTS=\"-javaagent:\/opt\/vertx\/current\/newrelic\/newrelic.jar /' -i vertx
    - cwd: /opt/vertx/current/bin
    - onlyif: if grep -q 'javaagent' vertx ; then false; else true; fi
    - require:
      - cmd: Change jar execution rights
