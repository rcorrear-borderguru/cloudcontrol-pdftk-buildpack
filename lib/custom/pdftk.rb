class Pdftk < BaseCustom

  def path
    "#{build_path}/vendor/#{name}"
  end

  def name
    "pdftk"
  end

  def source_url
    "https://raw.githubusercontent.com/SirRawlins/pdftk-source/master/pdftk.tar.gz"
    #"https://github.com/jornwanke-liquidlabs/cloudcontrol-pdftk-buildpack/blob/master/pdftk.tar.gz?raw=true"
  end

  def shell_script_url
    "https://github.com/rcorrear-borderguru/cloudcontrol-pdftk-buildpack/blob/master/libpath.sh?raw=true"
  end

  def build_path_profile		
    "#{build_path}/.profile.d"		
  end

  def used?
    File.exist?("#{build_path}/bin/pdftk") && File.exist?("#{build_path}/bin/lib/libgcj.so.12")
  end

  def compile
    write_stdout "compiling #{name} using #{path} and #{build_path}"
    #download the source and extract
    %x{ mkdir -p #{path} && curl --silent #{source_url} -o - | tar -xz -C #{path} -f - }

    %x{ mkdir -p #{build_path}/bin }
    %x{ mkdir -p #{build_path}/lib }
    %x{ cp #{path}/bin/pdftk #{build_path}/bin/pdftk } 
    %x{ cp #{path}/lib/libgcj.so.12 #{build_path}/lib/libgcj.so.12 } 

    %x{ mkdir -p #{build_path_profile} }
    %x{ curl --silent -L #{shell_script_url} -o - > #{build_path_profile}/pdftk.sh }

    write_stdout "complete compiling #{name}"
  end

  def cleanup!
  end

  def prepare
    File.delete("#{build_path}/bin/lib/libgcj.so.12") if File.exist?("#{build_path}/bin/libgcj.so.12")
    File.delete("#{build_path}/bin/pdftk") if File.exist?("#{build_path}/bin/pdftk")
  end

end
