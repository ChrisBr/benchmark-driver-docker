FROM opensuse:42.3

# Install dependencies
RUN zypper -n install --no-recommends --replacefiles \
  make gcc gcc-c++ patch curl vim vim-data psmisc \
  timezone ack glibc-locale sudo aaa_base hostname \
  ruby2.4 ruby2.4-devel ImageMagick ImageMagick-devel which git java tar
RUN zypper -n install --no-recommends --replacefiles ghostscript xorg-x11-fonts-core xorg-x11-fonts
RUN for i in ruby gem irb; do ln -s /usr/bin/$i.ruby2.4 /usr/local/bin/$i; done
RUN gem install rmagick benchmark_driver-output-gruff benchmark-driver

# Add our user
RUN useradd -m benchmark
RUN echo 'benchmark ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers

# Install rbenv
USER benchmark
RUN git clone https://github.com/rbenv/rbenv.git ~/.rbenv
RUN cd ~/.rbenv && src/configure && make -C src
RUN echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bash_profile
RUN mkdir -p "$(~/.rbenv/bin/rbenv root)"/plugins
RUN git clone https://github.com/rbenv/ruby-build.git "$(~/.rbenv/bin/rbenv root)"/plugins/ruby-build
RUN ~/.rbenv/bin/rbenv install jruby-9.2.0.0
RUN ~/.rbenv/bin/rbenv install jruby-9.2.1.0-dev

RUN mkdir -p home/benchmark/driver
WORKDIR /home/benchmark/driver

# Add patch for benchmark-driver
ADD bulk_output.rb /usr/lib64/ruby/gems/2.4.0/gems/benchmark_driver-0.14.6/lib/benchmark_driver/bulk_output.rb

CMD ["bash", "-l"]
