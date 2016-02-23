# -*- coding: binary -*-

module Rex
  module Java
    module Serialization
      module Model
        # This class provides a NewArray (Java Array) representation
        class NewArray < Element

          include Rex::Java::Serialization::Model::Contents

          # @!attribute array_description
          #   @return [Java::Serialization::Model::ClassDesc] The description of the array
          attr_accessor :array_description
          # @!attribute type
          #   @return [String] The type of the array values
          attr_accessor :type
          # @!attribute values
          #   @return [Array] The contents of the java array
          attr_accessor :values

          # @param stream [Rex::Java::Serialization::Model::Stream] the stream where it belongs to
          def initialize(stream = nil)
            super(stream)
            self.array_description = nil
            self.type = ''
            self.values = []
          end

          # Deserializes a Rex::Java::Serialization::Model::NewArray
          #
          # @param io [IO] the io to read from
          # @return [self] if deserialization succeeds
          # @raise [Rex::Java::Serialization::DecodeError] if deserialization doesn't succeed
          def decode(io)
            self.array_description = ClassDesc.decode(io, stream)
            stream.add_reference(self) unless stream.nil?
            self.type = array_type

            values_length = decode_values_length(io)

            values_length.times do
              value = decode_value(io)
              self.values << value
            end

            self
          end

          # Serializes the Rex::Java::Serialization::Model::NewArray
          #
          # @return [String] if serialization succeeds
          # @raise [Rex::Java::Serialization::EncodeError] if serialization doesn't succeed
          def encode
            unless array_description.kind_of?(ClassDesc)
              raise Rex::Java::Serialization::EncodeError, 'Failed to serialize NewArray'
            end

            encoded = ''
            encoded << array_description.encode

            encoded << [values.length].pack('N')

            values.each do |value|
              encoded << encode_value(value)
            end

            encoded
          end

          # Creates a print-friendly string representation
          #
          # @return [String]
          def to_s
            str = "#{type}, "
            values_data = values.collect {|v| "#{v}"}
            str << "#{values_data}"
          end

          private

          # Deserializes the NewArray length
          #
          # @param io [IO] the io to read from
          # @return [Integer] if deserialization succeeds
          # @raise [Rex::Java::Serialization::DecodeError] if deserialization doesn't succeed
          def decode_values_length(io)
            values_length = io.read(4)
            if values_length.nil? || values_length.length != 4
              raise Rex::Java::Serialization::DecodeError, 'Failed to unserialize NewArray'
            end

            values_length.unpack('N')[0]
          end

          # Extracts the NewArray data type
          #
          # @return [String]
          # @raise [Rex::Java::Serialization::DecodeError] if the NewArray description isn't valid
          #   or type isn't supported
          def array_type
            if array_description.nil?
              raise Rex::Java::Serialization::DecodeError, 'Empty NewArray description'
            end

            unless array_description.kind_of?(ClassDesc)
              raise Rex::Java::Serialization::DecodeError, 'Unsupported NewArray description class'
            end

            desc = array_description.description

            if desc.class == Reference
              ref = desc.handle - BASE_WIRE_HANDLE
              desc = stream.references[ref]
            end

            unless desc.class_name.contents[0] == '[' # Array
              raise Rex::Java::Serialization::DecodeError, 'Unsupported NewArray description'
            end

            decoded_type = desc.class_name.contents[1]
            if PRIMITIVE_TYPE_CODES.keys.include?(decoded_type)
              return PRIMITIVE_TYPE_CODES[decoded_type]
            elsif decoded_type == 'L' # L : Object
              return desc.class_name.contents[2..desc.class_name.contents.index(';')] # Object class
            else
              raise Rex::Java::Serialization::DecodeError, 'Unsupported NewArray Type'
            end
          end

          # Deserializes a NewArray value
          #
          # @param io [IO] the io to read from
          # @return [Fixnum, Float] if deserialization succeeds
          # @raise [Rex::Java::Serialization::DecodeError] if deserialization fails
          def decode_value(io)
            value = nil

            case type
            when 'byte'
              value = io.read(1)
              raise Rex::Java::Serialization::DecodeError, 'Failed to deserialize NewArray value' if value.nil?
              value = value.unpack('c')[0]
            when 'char'
              value = io.read(2)
              unless value && value.length == 2
                raise Rex::Java::Serialization::DecodeError, 'Failed to deserialize NewArray value'
              end
              value = value.unpack('s>')[0]
            when 'double'
              value = io.read(8)
              unless value && value.length == 8
                raise Rex::Java::Serialization::DecodeError, 'Failed to deserialize NewArray value'
              end
              value = value.unpack('G')[0]
            when 'float'
              value = io.read(4)
              unless value && value.length == 4
                raise Rex::Java::Serialization::DecodeError, 'Failed to deserialize NewArray value'
              end
              value = value.unpack('g')[0]
            when 'int'
              value = io.read(4)
              unless value && value.length == 4
                raise Rex::Java::Serialization::DecodeError, 'Failed to deserialize NewArray value'
              end
              value = value.unpack('l>')[0]
            when 'long'
              value = io.read(8)
              unless value && value.length == 8
                raise Rex::Java::Serialization::DecodeError, 'Failed to deserialize NewArray value'
              end
              value = value.unpack('q>')[0]
            when 'short'
              value = io.read(2)
              unless value && value.length == 2
                raise Rex::Java::Serialization::DecodeError, 'Failed to deserialize NewArray value'
              end
              value = value.unpack('s>')[0]
            when 'boolean'
              value = io.read(1)
              raise Rex::Java::Serialization::DecodeError, 'Failed to deserialize NewArray value' if value.nil?
              value = value.unpack('c')[0]
            else # object
              value = decode_content(io, stream)
            end

            value
          end

          # Serializes an NewArray value
          #
          # @param value [<Fixnum, Float>] the value to serialize
          # @return [String] the serialized value
          # @raise [Rex::Java::Serialization::EncodeError] if serialization fails
          def encode_value(value)
            res = ''

            case type
            when 'byte'
              res = [value].pack('c')
            when 'char'
              res = [value].pack('s>')
            when 'double'
              res = [value].pack('G')
            when 'float'
              res = [value].pack('g')
            when 'int'
              res = [value].pack('l>')
            when 'long'
              res = [value].pack('q>')
            when 'short'
              res = [value].pack('s>')
            when 'boolean'
              res = [value].pack('c')
            when Element
              res = value.encode
            else # object
              res = encode_content(value)
            end

            res
          end

        end
      end
    end
  end
end
