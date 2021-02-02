module "staticwebsite" {
source = "../modules/s3_static_website"
bucketname = "searchengine-staticwebsite"
}