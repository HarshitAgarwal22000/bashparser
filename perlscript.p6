#!/usr/bin/perl
use strict;
use warnings;
my $log_file = 'access.log';
open my $log_fh, '<', $log_file;
my %days_data;
my ($highest_requested_host, $highest_requested_upstream_ip, $highest_requested_path);
while (my $line = <$log_fh>) {
chomp $line;
my ($ip, $tp, $ht, $path, $htv, $status_code, $response_time, $upstream_ip, $body_bytes_sent, $host) = split / /, $line;
my ($day) = $tp =~ /(\d{2}\/\w+\/\d{4})/;
    $days_data{$day}{host}{$host}++;
    $days_data{$day}{upstream_ip}{$upstream_ip}++;
    my ($top_path) = $path =~ m!/(.*?/.*?)/!;
    $days_data{$day}{path}{$top_path}++;
}
print <<"HTML";
<!DOCTYPE html>
<html>
<head>
    <title>Log Summary</title>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
</head>
<body>

<h2>Log Summary</h2>

HTML


foreach my $day (sort keys %days_data) {
    print <<"HTML";
<div class="container">
    <button class="btn btn-primary" type="button" data-toggle="collapse" data-target="#$day" aria-expanded="false" aria-controls="$day">
        $day
    </button>
    <div class="collapse" id="$day">
        <div class="card card-body">
            <h3>Highest requested host:</h3>
            <p>@{[ highest_requested($days_data{$day}{host}) ]}</p>
            
            <h3>Highest requested upstream_ip:</h3>
            <p>@{[ highest_requested($days_data{$day}{upstream_ip}) ]}</p>
            
            <h3>Highest requested path (up to 2 subdirectories):</h3>
            <p>@{[ highest_requested($days_data{$day}{path}) ]}</p>
        </div>
    </div>
</div>

HTML
}
print <<"HTML";
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.16.0/umd/popper.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>

</html>
HTML