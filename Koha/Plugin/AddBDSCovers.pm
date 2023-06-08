package Koha::Plugin::AddBDSCovers;

use Modern::Perl;

use base qw(Koha::Plugins::Base);

our $VERSION = "4.0";

our $metadata = {
    name            => 'AddBDSCovers',
    author          => 'Matt Blenkinsop',
    date_authored   => '2022-01-11',
    date_updated    => "2022-04-19",
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

sub intranet_cover_images {
	my ( $self ) = @_;
    my $cgi = $self->{'cgi'};
    my $script_name = $cgi->script_name;

	my $js = <<'JS';
    <script>
      function addBDSCovers(e) {
        const search_results_images = document.querySelectorAll('.cover-slides, .cover-slider');
        if(search_results_images.length > 0){
            search_results_images.forEach((div, i) => {
                let { isbn, biblionumber, processedbiblio } = div.dataset
                if(isbn){
                    div.innerHTML += `
                        <div id="bds-coverimg-${biblionumber}" class="cover-image">
                            <a href=${ processedbiblio ? processedbiblio : `http://www.bibdsl.co.uk/xmla/image-service.asp?ISBN=${isbn}&amp;SIZE=l&amp;DBM=B` } >
                                <img src="http://www.bibdsl.co.uk/xmla/image-service.asp?ISBN=${isbn}&amp;SIZE=s&amp;DBM=B" alt="BDS cover image" />
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

sub opac_cover_images {
    my ( $self ) = @_;
    my $cgi = $self->{'cgi'};
    my $script_name = $cgi->script_name;

    my $js = <<'JS';
    <script>
      function addBDSCoversOPAC(e) {
        const search_results_images = document.querySelectorAll('.cover-slides, .cover-slider');
        if(search_results_images.length > 0){
            search_results_images.forEach((div, i) => {
                let { isbn, imgtitle } =  div.dataset;
                if(isbn){
                    div.innerHTML += `
                        <div class=${ imgtitle ? "" : "cover-image" }>
                            <a href="http://www.bibdsl.co.uk/xmla/image-service.asp?ISBN=${isbn}&amp;SIZE=l&amp;DBM=B" />
                                <img src="http://www.bibdsl.co.uk/xmla/image-service.asp?ISBN=${isbn}&amp;SIZE=s&amp;DBM=B" alt="BDS cover image" class=${ imgtitle ? "item-thumbnail" : "" } />
                            </a>
                        </div>
                        <div class="hint">Image from BDS</div>
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