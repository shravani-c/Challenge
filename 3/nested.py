def get_in(data,key):
  keys=key.split("/")
  try:
    if len(keys) == 1:
        return data[key]
    return get_in(data[keys[0]],"/".join(keys[1:]))
  except:
    return "nil"

if __name__ == "__main__":
  data={"a":{"b":{"c":{"d":"f"},'e':'g'}}}
  key="a/b/c/d"
  print("Object: %s"%(data))
  print("Key %s : %s" % (key, get_in(data, key)))
