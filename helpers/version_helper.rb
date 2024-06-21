# Module for application versioning
module VersionHelper
  # Load version from file
  # @return [String] version
  def self.load_version
    file_path = 'VERSION'
    if File.exist?(file_path)
      File.read(file_path).strip
    else
      '0.0.0'
    end
  end
end
