def copy_file_to_public_folder():
s3 = boto3.resource('s3')

src_bucket = s3.Bucket("bucket_A")
dst_bucket = "bucket_B"

for obj in src_bucket.objects.filter(Suffix='jpg'):
    print(obj.key)
    copy_source = {'Bucket': "bucket_A", 'Key': obj.key}
    
    dst_file_name = obj.key 
    s3.meta.client.copy(copy_source, dst_bucket, dst_file_name)