#
# This check is required because libssl1.1, which is deprecated, is required by
# wkhtmltopdf-binary (0.12.6.6), which was released Nov 30, 2022.
#
# This file can be removed if wkhtmltopdf-binary 0.12.6.6 is no longer used.
#

unless File.exist?('/usr/lib/x86_64-linux-gnu/libssl.so.1.1')
  raise 'Error: libssl.so.1.1 does not exist!'
end

unless File.exist?('/usr/lib/x86_64-linux-gnu/libcrypto.so.1.1')
  raise 'Error: libcrypto.so.1.1 does not exist!'
end
