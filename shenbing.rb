# encoding: utf-8
require "open-uri"
require 'fileutils'
class DownloadImages
  attr_accessor :chapter

  def initialize(chapter)
    @chapter = chapter
  end

  def download
    (1..@chapter.to_i).each do |chapter|
      FileUtils.mkdir chapter.to_s unless File.directory?(chapter.to_s)
      (1..100).each do |page|
        #remote_url = "#{base_url(chapter)}/#{sprintf('%03d',page)}.jpg"
        remote_url = "#{base_url_2(chapter)}/#{sprintf('%03d',page)}.jpg"
        puts remote_url
        save_url = "#{chapter}/#{page}.jpg"
        next if File.exists? save_url
        begin
          open(URI::encode(remote_url)) do |f|
            File.open(save_url,"wb") do |file|
              file.puts f.read
            end
          end
          puts "第#{chapter}章 => 第#{page}页 下载完成!"
        rescue Exception => e
          puts e.message
          break if e.message == "404 Not Found"
        end
      end
    end
  end

  # 神兵玄奇1
  def base_url(chapter)
    base_url = "http://p11.tuku.cc:8899/1300/神兵玄奇1高清晰版/#{chapter}"
    base_url = "http://p11.tuku.cc:8899/3300/01/sb/#{chapter}" if chapter > 90
    base_url = "http://p11.tuku.cc:8899/3300/01/sb/096-097" if [96, 97].include? chapter
    base_url = "http://p11.tuku.cc:8899/3300/01/sb/0#{chapter}" if [98, 99].include? chapter
    base_url = "http://p11.tuku.cc:8899/3500/sb/#{chapter}" if chapter > 105
    base_url = "http://p11.tuku.cc:8899/3500/3564/#{chapter}" if chapter > 130
    base_url
  end
  
  # 神兵玄奇2
  def base_url_2(chapter)
    base_url = "http://p11.tuku.cc:8899/3500/8850/#{chapter}"
    base_url = "http://p11.tuku.cc:8899/3500/8850/5-6" if [5, 6].include? chapter
    base_url = "http://p11.tuku.cc:8899/3600/8850/#{chapter}" if chapter > 25
    base_url = "http://p11.tuku.cc:8899/3700/8850/#{chapter}" if chapter > 45 
    base_url
  end

end

# 1
# download = DownloadImages.new(146)

# 2
# download = DownloadImages.new(100)

# download.download
