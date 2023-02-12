copyWith :
we can change a single value without disturbing others
UserModel user = UserModel(name : 'rohan', email: 'abc@twitte.com', ... );
user.copyWith(name:'veer');