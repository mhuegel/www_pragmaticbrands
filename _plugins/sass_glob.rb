require "fileutils"

Jekyll::Hooks.register :site, :after_reset do |site|
  sass_directory = File.join(site.source, "_sass")
  output_file = File.join(sass_directory, "_all.scss")

  files = Dir.glob(File.join(sass_directory, "*", "**", "*.scss"))
  .reject { |file| file == output_file }
  .sort

  imports = files.map do |file|
    relative_path = file
      .delete_prefix("#{sass_directory}/")
      .sub(%r{(^|/)_}, '\1')
      .sub(/\.scss$/, "")

    %(@import "#{relative_path}";)
  end

  content = <<~SCSS
    // Generated automatically.
    // Do not edit manually.

    #{imports.join("\n")}
  SCSS

  unless File.exist?(output_file) && File.read(output_file) == content
    File.write(output_file, content)
  end
end
