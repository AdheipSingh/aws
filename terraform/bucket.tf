provider "aws" {
        access_key = ""
        secret_key = ""
        region = "ap-south-1"
}



resource "aws_s3_bucket" "bucket" {
	bucket = "adheip.singh.sadhrao"
	acl = "public-read"
	"website" {
	 index_document = "index.html"
	}
}
resource "aws_cloudfront_distribution" "distribution" {
	origin {
	  domain_name = "${aws_s3_bucket.bucket.bucket}.s3.amazonaws.com"
	  origin_id  = "website"
	}
	enabled = true
	is_ipv6_enabled = true
		aliases = [
	 "${aws_s3_bucket.bucket.bucket}"
	]

	default_root_object = "index.html"

	"restrictions" {
	 "geo_restriction" {
		restriction_type = "none"
	}
     }
	viewer_certificate {
	 acm_certificate_arn = "arn:aws:--region:--no--:certificate/--no--"
	 ssl_support_method = "sni-only"
	 minimum_protocol_version = "TLSv1"
}
	"default_cache_behavior" {
	  allowed_methods = {"HEAD" , "GET"}
	  cached_methods = {"HEAD" , "GET" }
	   "forwarded_values" {
		query_string = false
		"cookies"{
		  forward = "none"
	}
}
	   default_ttl = 0
	   max_ttl = 0
	   min_ttl = 0
	   target_origin_id = "website"
	   viewer_protocol_policy = "redirect-to-https"
	   compress = true


}

}

	
