module Destiny

  ###
  # Utils: A module that contains various useful methods that can be used across all files in this gem.
  module Utils

    ###
    # url_encode: Manipulates a hash into a query string.
    def url_encode(hash)
      hash.to_a.map do |a|
        a.map.with_index do |b,i|
          if i.eql?(1) && !b.is_a?(String)
            MultiJson.dump(b)
          else
            b
          end
        end.join '='
      end.join '&'
    end

    ###
    # url_unpack: Manipulates a query string into a hash.
    def url_unpack(str)
      hash = {}

      CGI::parse(str).to_a.map do |a|
        if a.last.first.start_with?('[') and a.last.first.end_with?(']')
          hash[a.first.to_sym] = a.last.first.split(",").map do |b|
            if b.start_with?('[') or b.end_with?(']')
              b = b.gsub('[','').gsub(']','')
            end

            b.gsub('\"','').gsub('\\','')
          end
        elsif a.last.first.is_i?
          hash[a.first.to_sym] = a.last.first.to_i
        else
          hash[a.first.to_sym] = a.last.first
        end
      end

      hash
    end

    ###
    # resourceify: Takes a file name and converts it to a Class name.
    def resourceify(name)
      name.to_s.split('_').map! do |s|
        [s[0,1].capitalize, s[1..-1]].join
      end.join
    end
  end
end

class String
  def is_i?
    !!(self =~ /\A[-+]?[0-9]+\z/)
  end
end