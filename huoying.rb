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
      (1..200).each do |page|
        remote_url = "#{base_url(chapter)}/#{page_name(page)}.jpg"
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

  def base_url(chapter)
    base_url = "http://www1.fzdm.com/1/Vol_#{sprintf('%03d',chapter)}"
    base_url
  end

  def page_name(page)
    str = 'abcdefghijklmnopqistuvwxyz'
    index_1 = str[ ( page - 1 ) / 13 ]
    index_2 = str[ 2 * ( page.to_i % 13 ) - 2 ]
    "#{sprintf('%03d',page)}#{index_1}#{index_2}"
  end

end

# 2
download = DownloadImages.new(618)

download.download
