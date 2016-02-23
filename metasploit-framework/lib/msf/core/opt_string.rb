# -*- coding: binary -*-

module Msf

###
#
# Mult-byte character string option.
#
###
class OptString < OptBase
  def type
    return 'string'
  end

  def normalize(value)
    if (value =~ /^file:(.*)/)
      path = $1
      begin
        value = File.read(path)
      rescue ::Errno::ENOENT, ::Errno::EISDIR
        value = nil
      end
    end
    value
  end

  def valid?(value=self.value)
    value = normalize(value)
    return false if empty_required_value?(value)
    return super
  end
end

end
