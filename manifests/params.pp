#Parameter file
class artifactory::params {
	$user                        = "artifactory"
	$group                       = "artifactory"
	$version                     = $::artifactory::version
	$java_version                = $::artifactory::java_version
	$source                      = "/tmp"
	$destination                 = "/opt/jfrog/artifactory"
	
        if ($version =~ /^2/) or ($version =~ /^3/) {    
           $artifactory_type = 'undef'
        }
	else {
   	   $artifactory_type = hiera('artifactory::params::artifactory_type', 'oss') 
        }

	case $java_version {
	      '7': {    $Xms           = '512m'
		        $Xmx           = '2g'
		        $Xss           = '256k'
	      		$PermSize      = '128m'
	    	        $MaxPermSize   = '256m' 
              }

	      '8': {    $Xms           = '512m'
	                $Xmx           = '2g'
	                $Xss           = '256k' 
	      }	
	}
  
	case $::osfamily {
	     'Debian': {   $repo_type     = "deb"
		           $repo_provider = "dpkg"
               		   $package_java_name  = "openjdk-${java_version}-jdk"
                    if $artifactory_type == "pro" {
                           $package_artifactory_name    = "jfrog-artifactory-${artifactory_type}"
                           $path                        = "pool/main/j/jfrog-artifactory-${artifactory_type}-${repo_type}"
                           $repo_source                 = "http://jfrog.bintray.com/artifactory-${artifactory_type}-${repo_type}s/${path}/jfrog-artifactory-${artifactory_type}-${version}.${repo_type}"
                    }
                    if $artifactory_type == "oss" {
                           $package_artifactory_name    = "jfrog-artifactory-${artifactory_type}"
                           $path                        = "pool/main/j/jfrog-artifactory-${artifactory_type}-${repo_type}"
                           $repo_source                 = "http://jfrog.bintray.com/artifactory-${repo_type}s/${path}/jfrog-artifactory-${artifactory_type}-${version}.${repo_type}"
                    }
             }
	     'Redhat': { 
	                   $repo_type           = "rpm" 
		           $repo_provider       = "rpm" 
			   $package_java_name   = "java-1.${java_version}.0-openjdk"
	                 if $artifactory_type == "pro" {
	                   $package_artifactory_name    = "jfrog-artifactory-${artifactory_type}"
	                   $path                        = "org/artifactory/${artifactory_type}/${repo_type}/jfrog-artifactory-${repo_type}/${version}"
	                   $repo_source                 = "http://jfrog.bintray.com/artifactory-${artifactory_type}-${repo_type}s/$path/jfrog-artifactory${artifactory_type}-${version}.${repo_type}"
	                 }
	                 if  $artifactory_type == "oss" {
	                   $package_artifactory_name    = "jfrog-artifactory-${artifactory_type}"
	                   $repo_source                 = "http://jfrog.bintray.com/artifactory-${repo_type}s/jfrog-artifactory-${artifactory_type}-${version}.${repo_type}"
	                 }
	                 if  $artifactory_type == "unef" { 
	                   $package_artifactory_name    = "artifactory"
	                   $repo_source                 = "http://jfrog.bintray.com/artifactory-${repo_type}s/artifactory-${version}.${repo_type}"
	                }
	     }
      }
}
