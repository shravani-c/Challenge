from pprint import pprint
from boto import ec2

#AWS credentials 
AWS_ACCESS_KEY_ID = 'XXXX'
AWS_SECRET_ACCESS_KEY = 'XXXX'

#connection to ec2 instances
ec2conn = ec2.connection.EC2Connection(AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY)
reservations = ec2conn.get_all_instances()
instances = [i for r in reservations for i in r.instances]
for i in instances:
    pprint(i.__dict__)
    break # remove this to list all instances
