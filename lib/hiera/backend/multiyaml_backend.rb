require 'hiera/backend/yaml_backend'

class Hiera
  module Backend
    class Multiyaml_backend
      # XXX: There is no option to override the datadir/datafile function logic
      # in Hiera::Backend, so there is a lot of copy paste code from
      # Hiera::Backend and Hiera::Backend::Yaml_backend instead of inheritance
      # or just calling it from here. The Hiera architecture sucks big time. :-(

      def initialize(cache=nil)
        require 'yaml'
        Hiera.debug("Hiera MultiYAML backend starting")

        @cache = cache || Filecache.new
      end

      def lookup(key, scope, order_override, resolution_type)
        answer = nil

        Config[:multiyaml][:backends].each do |backend|
          backend = backend.to_sym

          Backend.datasources(scope, order_override) do |source|
            Hiera.debug("Looking for data source #{source} in MultiYAML #{backend}")
            yamlfile = File.join(Config[backend][:datadir], "#{source}.yaml")

            if not File.exist?(yamlfile)
              Hiera.debug("Cannot find datafile #{yamlfile}, skipping")
              next
            end

            data = @cache.read_file(yamlfile, Hash) do |data|
              YAML.load(data)
            end

            next if data.empty?
            next unless data.include?(key)

            Hiera.debug("Found #{key} in #{backend}/#{source}")

            new_answer = Backend.parse_answer(data[key], scope)
            answer = merge_answer(resolution_type, new_answer, answer)
          end
        end

        return answer
      end

      def merge_answer(resolution_type, new_answer, answer)
        if not new_answer.nil?
          case resolution_type
          when :array
            raise Exception, "Hiera type mismatch: expected Array and got #{new_answer.class}" unless new_answer.kind_of? Array or new_answer.kind_of? String
            answer ||= []
            answer << new_answer
          when :hash
            raise Exception, "Hiera type mismatch: expected Hash and got #{new_answer.class}" unless new_answer.kind_of? Hash
            answer ||= {}
            answer = Hiera::Backend.merge_answer(new_answer,answer)
          else
            answer = new_answer
          end
        end
        return answer
      end
    end
  end
end
