#  Copyright 2019,2020 IBM
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.

FROM node:alpine
LABEL maintainer="philippe_mulet@fr.ibm.com"

# hadolint ignore=DL3017
RUN apk update && apk upgrade

# Install the application
COPY package.json /app/package.json
COPY app.js /app/app.js
WORKDIR /app
RUN npm install

# Support to for arbitrary UserIds
# https://docs.openshift.com/container-platform/3.11/creating_images/guidelines.html#openshift-specific-guidelines
RUN chmod -R u+x /app && \
    chgrp -R 0 /app && \
    chmod -R g=u /app /etc/passwd

ENV PORT 8080
EXPOSE 8080

# Vulnerability Advisor : Fix PASS_MAX_DAYS, PASS_MIN_DAYS and PASS_MIN_LEN, common-password
# RUN mv -f /etc/login.defs /etc/login.defs.orig
# RUN sed 's/^PASS_MAX_DAYS.*/PASS_MAX_DAYS 90/' /etc/login.defs.orig > /etc/login.defs
# RUN grep -q '^PASS_MIN_DAYS' /etc/login.defs && sed -i 's/^PASS_MIN_DAYS.*/PASS_MIN_DAYS 1/' /etc/login.defs || echo 'PASS_MIN_DAYS 1\n' >> /etc/login.defs
# RUN grep -q '^PASS_MIN_LEN' /etc/login.defs && sed -i 's/^PASS_MIN_LEN.*/PASS_MIN_LEN 8/' /etc/login.defs || echo 'PASS_MIN_LEN 9\n' >> /etc/login.defs
# RUN grep -q '^password.*required' /etc/pam.d/common-password && sed -i 's/^password.*required.*/password    required            pam_permit.so minlen=9/' /etc/pam.d/common-password || echo 'password    required            pam_permit.so minlen=9' >> /etc/pam.d/common-password
# Vulnerability Advisor : Temporarily remove a specific <package> that was discovered vulnerable
# RUN dpkg --purge --force-all <package>

# Define command to run the application when the container starts
CMD ["node", "app.js"]
