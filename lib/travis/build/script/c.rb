module Travis
  module Build
    class Script
      class C < Script
        DEFAULTS = {
          compiler: 'gcc'
        }

        def export
          super
          sh.export 'CC', compiler
        end

        def announce
          super
          sh.cmd "#{compiler} --version"
        end

        def script
          sh.cmd './configure && make && make test'
        end

        def cache_slug
          super << '--compiler-' << compiler
        end

        def install
          super
          sh.export 'CCACHE_DISABLE', 'true', echo: false
          if data.cache?(:ccache)
            sh.export 'CCACHE_DISABLE', 'false', echo: false
            directory_cache.add('~/.ccache')
          end
        end

        def use_directory_cache?
          super || data.cache?(:ccache)
        end

        private

          def compiler
            config[:compiler].to_s
          end
      end
    end
  end
end
