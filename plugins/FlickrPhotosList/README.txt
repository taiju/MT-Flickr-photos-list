---------------------------------------------------------
Copyright(c) 2010
author: taiju

Flickr photos List Plugin
---------------------------------------------------------
Flickr photos List Plugin
  This is Movabletype plugin. This plugin get photos from flickr, and outputs ul or ol element.

Installation
  Simply drop the directory `plugins/FlickrPhotosList` contained in this archive into
your `$MT_HOME/plugins` directory.


Use
  You set this plugin settings and enter template tag on template.

      <$MTFlickrPL$>
           or
      <$mt:flickrpl$>

  Use modifiers
    You can use modifiers.
    Modifieres that you can use are user_id, per_page, extras, and list_style.

      <$mt:flickrpl list_style="ul" extras="url_t" per_page="20" user_id=".......@N.."$>

Lisense
  Please refer to FlickrPhotosList-LISENSE.txt
