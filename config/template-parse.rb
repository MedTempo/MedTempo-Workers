require "liquid"
require "liquid"

@templates = Hash.new

def load_template

    Dir["./templates/*.liquid"].each_with_index do
        | file, index |
        puts "#{index}) Templates - #{file}"

        @templates["#{File.basename(file, '.*')}"] = Liquid::Template.parse(File.read(file), error_mode: :strict)
    end

    puts "\nAll Templates Have Been Loaded!\n\n"
end


load_template()



#.render({ "person" => "Hello", "vcode" => 1234 })