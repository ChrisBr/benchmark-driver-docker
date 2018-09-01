FROM opensuse:42.3

# Install dependencies
RUN zypper -n install --no-recommends --replacefiles \
  make gcc gcc-c++ patch curl vim vim-data psmisc \
  timezone ack glibc-locale sudo aaa_base hostname \
  ruby2.4 ruby2.4-devel ImageMagick ImageMagick-devel which git java \ 
  tar ghostscript xorg-x11-fonts-core xorg-x11-fonts

RUN for i in ruby gem irb; do ln -s /usr/bin/$i.ruby2.4 /usr/local/bin/$i; done
RUN gem install rmagick benchmark_driver-output-gruff benchmark-driver

# Add our user
RUN useradd -m benchmark
RUN echo 'benchmark ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers

USER benchmark

RUN mkdir -p home/benchmark/driver
WORKDIR /home/benchmark/driver
ADD runner.rb /usr/lib64/ruby/gems/2.4.0/gems/benchmark_driver-0.14.8/lib/benchmark_driver/runner.rb

CMD ["bash", "-l"]
