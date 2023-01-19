package Koha::Plugin::AddBDSCovers;

use Modern::Perl;

use base qw(Koha::Plugins::Base);

our $VERSION = "1.1";

our $metadata = {
    name            => 'AddBDSCovers',
    author          => 'Matt Blenkinsop',
    date_authored   => '2022-01-11',
    date_updated    => "2022-01-19",
    minimum_version => '19.05.00.000',
    maximum_version => undef,
    version         => $VERSION,
    description     => 'This plugin adds BDS cover images to biblio records and search results.',
};

sub new {
    my ( $class, $args ) = @_;

    $args->{'metadata'} = $metadata;
    $args->{'metadata'}->{'class'} = $class;

    my $self = $class->SUPER::new($args);
    $self->{cgi} = CGI->new();

    return $self;
}

sub intranet_js {
	my ( $self ) = @_;
    my $cgi = $self->{'cgi'};
    my $script_name = $cgi->script_name;

	my $js = <<'JS';
    <script>
      // Cover Image Plugin
      function addBDSCovers(e) {
        const cover_image_div = document.querySelector('.cover_images_required');
        if(cover_image_div) {
            cover_image_div.innerHTML += `
                <div class="cover-image">
                    <a href="http://www.bibdsl.co.uk/xmla/image-service.asp?ISBN=${normalized_isbn}&amp;SIZE=l&amp;DBM=B" />
                        <img src="http://www.bibdsl.co.uk/xmla/image-service.asp?ISBN=${normalized_isbn}&amp;SIZE=s&amp;DBM=B" alt="BDS cover image" />
                    </a>
                    <div class="hint">BDS cover image</div>
                </div>
            `;
        }
        const search_results_images = document.querySelectorAll('.search_cover_images_required');
        if(search_results_images.length > 0){
            search_results_images.forEach((div, i) => {
                if(search_results[i + 1].isbn){
                    div.innerHTML += `
                        <div id="bds-coverimg-${search_results[i + 1].biblionumber}" class="cover-image bds-coverimg">
                            <a href=${search_results[i + 1].processedBiblio}>
                                <img src="http://www.bibdsl.co.uk/xmla/image-service.asp?ISBN=${search_results[i + 1].isbn}&amp;SIZE=s&amp;DBM=B" alt="BDS cover image" />
                            </a>
                            <div class="hint">BDS cover image</div>
                        </div>
                    `;
                }
            })
        }
      }
      document.addEventListener('DOMContentLoaded', addBDSCovers, false);
    </script>
JS

    return "$js";
}

sub opac_js {
    my ( $self ) = @_;
    my $cgi = $self->{'cgi'};
    my $script_name = $cgi->script_name;

    my $js = <<'JS';
    <script>
      // Cover Image Plugin
      function addBDSCoversOPAC(e) {
        const cover_image_div = document.querySelector('.cover_images_required');
        if(cover_image_div) {
            cover_image_div.innerHTML += `
                <div class="cover-image">
                    <a href="http://www.bibdsl.co.uk/xmla/image-service.asp?ISBN=${normalized_isbn}&amp;SIZE=l&amp;DBM=B" />
                        <img src="http://www.bibdsl.co.uk/xmla/image-service.asp?ISBN=${normalized_isbn}&amp;SIZE=s&amp;DBM=B" alt="BDS cover image" />
                    </a>
                </div>
                <div class="hint">Image from BDS</div>
            `;
        }
        const search_results_images = document.querySelectorAll('.search_cover_images_required');
        if(search_results_images.length > 0){
            search_results_images.forEach((div, i) => {
                if(search_results[i + 1].isbn){
                    div.innerHTML += `
                        <span title="${search_results[i + 1].img_title}" id="bds-thumbnail${i + 1}">
                            <img src="http://www.bibdsl.co.uk/xmla/image-service.asp?ISBN=${search_results[i + 1].isbn}&amp;SIZE=s&amp;DBM=B" alt="BDS cover image" class="item-thumbnail" />
                        </span>
                    `;
                } else {
                    div.innerHTML += `<span class="no-image">No cover image available</span>`;
                }
            })
        }
      }
      document.addEventListener('DOMContentLoaded', addBDSCoversOPAC, false);
    </script>
JS

    return "$js";
}

1;
