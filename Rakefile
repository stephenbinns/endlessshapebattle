task :build_standalone do
  rm_rf 'pkg/osx'
  mkdir 'pkg/osx'

  `unzip wrappers/Ruby.app.zip -d pkg/osx`

  cp_r Dir.glob('*.rb'), 'pkg/osx/Ruby.app/Contents/Resources/'
  cp_r Dir.glob('*.yml'), 'pkg/osx/Ruby.app/Contents/Resources/'
  cp_r Dir.glob('lib/*.rb'), 'pkg/osx/Ruby.app/Contents/Resources/lib/'
  mkdir 'pkg/osx/Ruby.app/Contents/Resources/media'
  cp_r Dir.glob('media/*.*'), 'pkg/osx/Ruby.app/Contents/Resources/media/'

  cd 'pkg/osx/Ruby.app/Contents/Resources/'
  rm 'main.rb'
  mv 'esb.rb', 'main.rb'

  cd '../../..'
  mv 'Ruby.app', 'ESB.app'
end
