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
    "https://github.com/jornwanke-liquidlabs/cloudcontrol-pdftk-buildpack/blob/master/libpath.sh?raw=true"
  end

  def profile
    "${HOME}/.profile.d"
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
    %x{ cd #{path} && ls -R #{path} 1>&2 }
    write_stdout "--------------buildpath:"
    %x{ cd #{build_path} && ls #{build_path} 1>&2 }
    
    %x{ mkdir -p #{build_path}/bin }
    %x{ mkdir -p #{build_path}/bin/lib }
    %x{ mkdir -p #{build_path}/lib }
    %x{ cp #{path}/bin/pdftk #{build_path}/bin/pdftk } 
    %x{ cp #{path}/lib/libgcj.so.12 #{build_path}/lib/libgcj.so.12 } 
    %x{ cp #{path}/lib/libgcj.so.12 #{build_path}/bin/libgcj.so.12 } 
    %x{ cp #{path}/lib/libgcj.so.12 #{build_path}/bin/lib/libgcj.so.12 } 

    write_stdout "profile #{profile}"
    %x{ echo #{profile} 1>&2 }
    %x{ echo #{build_path_profile} 1>&2 }
    %x{ mkdir -p #{profile} && curl -L #{shell_script_url} -o - > /srv/www/.profile.d/pdftk.sh }
    %x{ mkdir -p #{build_path_profile} }
    %x{ cp #{profile}/pdftk.sh #{build_path_profile} }
    %x{ cat #{profile}/pdftk.sh 1>&2 }
    
    write_stdout "complete compiling #{name}"
  end

  def cleanup!
  end

  def prepare
    #File.delete("#{build_path}/bin/lib/libgcj.so.12") if File.exist?("#{build_path}/bin/libgcj.so.12")
    #File.delete("#{build_path}/bin/pdftk") if File.exist?("#{build_path}/bin/pdftk")
  end

end
