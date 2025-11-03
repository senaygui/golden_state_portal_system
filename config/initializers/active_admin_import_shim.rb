# Defensive shim for ActiveAdminImport to avoid nil csv_lines and expose file path for debugging.
# This file ensures the importer never returns nil for csv lines and adds a helper to retrieve
# the uploaded tempfile path when available. It is intentionally small and robust.
begin
  ActiveSupport.on_load(:after_initialize) do
    if defined?(ActiveAdminImport::Importer)
      module ActiveAdminImport
        module ImporterCsvLinesShim
          def csv_lines
            # Ensure @csv_lines is always an Array to avoid NoMethodError for map!
            val = instance_variable_get(:@csv_lines)
            return val if val.is_a?(Array)

            # Try to read from the file if available
            file_obj = instance_variable_get(:@file) rescue nil
            if file_obj.respond_to?(:path) && File.exist?(file_obj.path)
              begin
                require 'csv'
                rows = CSV.read(file_obj.path, headers: false, encoding: 'bom|utf-8')
                instance_variable_set(:@csv_lines, rows)
                return rows
              rescue => _e
                # fall through to ensure we at least return an array
              end
            end

            instance_variable_set(:@csv_lines, [])
            []
          end

          def uploaded_file_path
            file_obj = instance_variable_get(:@file) rescue nil
            return file_obj.path if file_obj.respond_to?(:path)
            file_obj.inspect
          end
        end

      end

      ActiveAdminImport::Importer.prepend(ActiveAdminImport::ImporterCsvLinesShim)
    end
  end
rescue => e
  Rails.logger.warn "[active_admin_import_shim] initialization failed: #{e.message}"
end
