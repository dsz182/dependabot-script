FROM dependabot/dependabot-core:0.172.2

ARG CODE_DIR=/home/dependabot/dependabot-script
RUN mkdir -p ${CODE_DIR}
COPY --chown=dependabot:dependabot Gemfile Gemfile.lock ${CODE_DIR}/
COPY native-helpers ${CODE_DIR}/
WORKDIR ${CODE_DIR}
ENV DEPENDABOT_NATIVE_HELPERS_PATH="$(pwd)/native-helpers"
ENV PATH="$PATH:$DEPENDABOT_NATIVE_HELPERS_PATH/terraform/bin:$DEPENDABOT_NATIVE_HELPERS_PATH/python/bin:$DEPENDABOT_NATIVE_HELPERS_PATH/go_modules/bin:$DEPENDABOT_NATIVE_HELPERS_PATH/dep/bin"
ENV MIX_HOME="$DEPENDABOT_NATIVE_HELPERS_PATH/hex/mix"

RUN bundle config set --local path "vendor" \
  && bundle install --jobs 4 --retry 3

COPY --chown=dependabot:dependabot . ${CODE_DIR}

CMD ["bundle", "exec", "ruby", "./generic-update-script.rb"]
