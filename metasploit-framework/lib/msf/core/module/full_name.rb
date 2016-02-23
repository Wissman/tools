# @note {Msf::Module::ModuleInfo#name} is unrelated to {#fullname} and should instead be thought of as the title or
#   summary of the module.
#
# Names related to {#fullname}, such as {#fullname}, {#refname}, and {#shortname}.
module Msf::Module::FullName
  extend ActiveSupport::Concern

  module ClassMethods
    #
    # Attributes
    #


    # @attribute refname
    #   The module's name that is assigned to it by the framework
    #   or derived from the path that the module is loaded from.
    attr_accessor :refname

    #
    # Class Methods
    #

    def fullname
      type + '/' + refname
    end

    def shortname
      refname.split('/').last
    end
  end

  #
  # Instance Methods
  #

  #
  # Returns the module's framework full reference name.  This is the
  # short name that end-users work with (refname) plus the type
  # of module prepended.  Ex:
  #
  # payloads/windows/shell/reverse_tcp
  #
  def fullname
    self.class.fullname
  end

  #
  # Returns the module's framework reference name.  This is the
  # short name that end-users work with.  Ex:
  #
  # windows/shell/reverse_tcp
  #
  def refname
    self.class.refname
  end

  #
  # Returns the module's framework short name.  This is a
  # possibly conflicting name used for things like console
  # prompts.
  #
  # reverse_tcp
  #
  def shortname
    self.class.shortname
  end
end
