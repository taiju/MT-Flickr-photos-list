package FlickrPhotosList::Plugin;

use strict;
use warnings;
use utf8;

use MT;
use MT::ErrorHandler;
use LWP::Simple;
use XML::Simple;

=head1 Flickr photos List Plugin

This is Movabletype plugin. This plugin get photos from flickr, and outputs ul or ol element.

=head1 Installation

Extract move to /path/to/mt/plugins/

=head1 Use

You set this plugin settings and enter template tag on template.

    <$MTFlickrPL$>
          or
    <$mt:flickrpl$>

=head2 Use modifiers

You can use modifiers.
Modifieres that you can use are user_id, per_page, extras, and list_style.

    <$mt:flickrpl list_style="ul" extras="url_t" per_page="20" user_id=".......@N.."$>

=head1 Lisense

Please refer to FlickrPhotosList-LISENSE.txt

=cut

sub tag {
    my ($ctx, $args) = @_;
    my $plugin = MT->component('FlickrPhotosList');

    my $list_style = defined $args->{list_style} ? $args->{list_style} : $plugin->get_config_value('list_style');

    my $params = {
        method => 'flickr.photos.search',
        api_key => $plugin->get_config_value('api_key'),
        user_id => defined $args->{user_id} ? $args->{user_id} : $plugin->get_config_value('user_id'),
        extras => defined $args->{extras} ? $args->{extras} : $plugin->get_config_value('extras'),
        per_page => defined $args->{per_page} ? $args->{per_page} : $plugin->get_config_value('per_page'),
    };

    my $content = get(_buildRequest('http://api.flickr.com/services/rest', $params));
    return $ctx->error("Flickrから写真を取得できませんでした。") unless defined $content;

    my $xmlobj = XMLin($content);
    return $ctx->error("Flickrから写真を取得できませんでした。Flickrで発生したエラーの詳細: $xmlobj->{err}->{msg}") if defined $xmlobj->{err};

    my %elem_photos = %{$xmlobj->{photos}->{photo}};
    my $url = "http://www.flickr.com/photos/$params->{user_id}/";
    my @lines = ();
    for my $id (keys %elem_photos) {
        my $line  = "<li><a href=\"$url$id/\"><img src=\"$elem_photos{$id}{$params->{extras}}\" alt=\"$elem_photos{$id}{title}\" /></a></li>";
        push(@lines, $line);
    }
    unshift(@lines, "<$list_style>");
    push(@lines, "</$list_style>");
    return join("\n", @lines);
}

sub _buildRequest {
    my ($api_url, $params) = @_;
    return "$api_url?" . join('&', map { "$_=$params->{$_}" } keys %{$params});
}


1;
