function uuid4 -d "generate a uuid4 and copy to clipboard"
    python -c 'import uuid; import sys; sys.stdout.write(str(uuid.uuid4()))' | pbcopy
end
