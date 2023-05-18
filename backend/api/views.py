from rest_framework.response import Response
from rest_framework.decorators import api_view
from django.db import connections

from api.helper_functions import generate_token


@api_view(['POST'])
def userLogin(request):
    cursor = connections['default'].cursor()
    

    if request.data.get('username') is not None and request.data.get('password') is not None:    
        users = cursor.execute("SELECT user_id FROM Base_user WHERE Username = '{username}' AND password = '{password}';".format(username=request.data['username'], password=request.data['password']))
        if users == 1:
            user_id = cursor.fetchone()[0]
            cursor = connections['default'].cursor()
            token: str = generate_token()
            cursor.execute("INSERT INTO base_tokens (token,user_id) VALUES ('{token}','{user_id}');".format(token=token, user_id=user_id))

            response: dict = {
                "token": token,
                "user_id": user_id
            }
            return Response(response, 200)
        else:
            return Response("User Not Found", 404)    
    return Response("Bad Argument", 400)

@api_view(['POST'])
def getOrdersDetails(request):
    cursor = connections['default'].cursor()

    if request.data.get('order_id') is not None:    
        order_user = cursor.execute("SELECT user_id from base_order where order_id = '{order_id}';".format(order_id=request.data['order_id']))
        if order_user == 1:
            user_id = cursor.fetchone()[0]
        cursor = connections['default'].cursor()
        cursor.execute("SELECT address from base_order inner join base_order_advertises on base_order.order_id = base_order_advertises.order_id where base_order.order_id in(select order_id from base_order where order_id = {order_id});".format(order_id=request.data['order_id']))

        address = cursor.fetchone()[0]

        ads_id = cursor.execute("select advertise_id from base_order_advertises where order_id = '{order_id}';".format(order_id=request.data['order_id']))
        advertise_list = []
        if ads_id >=1:
            for element in cursor.fetchall():
                advertise_id = element[0]
                advertise_list.append(advertise_id)
        
        order_ads = cursor.execute("SELECT sum(price) from base_advertisement inner join base_order_advertises on base_advertisement.advertise_id = base_order_advertises.advertise_id where base_order_advertises.order_id in(select order_id from base_order where order_id = {order_id});".format(order_id=request.data['order_id']))
        if order_ads ==1:
            total_price = cursor.fetchone()[0]
            response: dict = {
                "user_id":user_id,
                "address":address,
                "price":total_price,
                "advertises_id" : advertise_list
            }       
            return Response( response, 200)
        else:
            return Response("Order Not Found", 404)    
    return Response("Bad Argument", 400)

#orderIds
@api_view(['POST'])
def getOrdersIdsForSpecificUser(request):
    cursor = connections['default'].cursor()
    flag= False

    if request.data.get('user_id') is not None and request.data.get('token') is not None:    
        cursor.execute("SELECT token FROM base_tokens WHERE user_id = '{user_id}';".format(user_id=request.data['user_id']))
        token_value = cursor.fetchall();
        for element in token_value:
            print(element[0])
            print(request.data['token'])
            if element[0] == request.data['token']:
                flag = True
                break      
        #user_id = cursor.execute("SELECT user_id FROM base_order WHERE user_id = '{user_id}';".format(user_id=request.data['user_id']))
        if flag == True:
            order_numbers = cursor.execute("SELECT order_id FROM base_order WHERE user_id = '{user_id}';".format(user_id=request.data['user_id']))
            order_items_list = []
           
            if order_numbers >= 1:
                order_items_tuple_list = cursor.fetchall()

                for order_items_tuple in order_items_tuple_list:
                    order_items_list.append(order_items_tuple[0])

            return Response( order_items_list, 200)        
         
        else:                    
            return Response("Invalid token", 500)
    
    return Response("Bad Argument", 400)


@api_view(['POST'])
def getAdvertisesmentsIdsForSpecificUser(request):
    cursor = connections['default'].cursor()
    flag= False
    token_flag = False

    if request.data.get('user_id') is not None and request.data.get('token') is not None:    
        cursor.execute("SELECT user_id FROM base_vendor_user;")
        vendor_ids = cursor.fetchall();
        print(vendor_ids)
        #check if the user is vendor
        for element in vendor_ids:
            if element[0] == request.data['user_id']:
                flag = True
                break 
        print(flag)     
        #user_id = cursor.execute("SELECT user_id FROM base_order WHERE user_id = '{user_id}';".format(user_id=request.data['user_id']))
        if flag == True:
            token_number = cursor.execute("SELECT token FROM base_tokens WHERE user_id = '{user_id}';".format(user_id=request.data['user_id']))
            if token_number >= 1:
                token_value = cursor.fetchall()
                for element in token_value:
                    print(element[0])
                    print(request.data['token'] == element[0])
                    if element[0] == request.data['token']:
                        token_flag = True
                        break
            if token_flag == True:
                cursor.execute("select advertise_id from base_advertisement where user_id = '{user_id}';".format(user_id=request.data['user_id']))
                advertises_ids = cursor.fetchall()
                advertisements_ids = []

                for id in advertises_ids:
                    advertisements_ids.append(id[0])

                return Response( advertisements_ids, 200)    
            else:
                return Response("Invalid Token" , 400)
        else:
            return Response("the User is not Vendor" , 400)  
    else:
        return Response("Bad Argument", 400)

@api_view(['POST'])
def getAdvertisementDetails(request):
    cursor = connections['default'].cursor()

    if request.data.get('advertise_id') is not None:    
        adverCount = cursor.execute("SELECT * FROM `base_advertisement` WHERE advertise_id = {advertise_id};"
                                    .format(advertise_id =request.data.get('advertise_id')))
        if(adverCount == 1):
            adverData = cursor.fetchone()
            mydevertise = {
                        'advertise_id': adverData[1],
                        'name': adverData[2],
                        'price': adverData[0],
                        'quantity': adverData[3],
                        'description': adverData[4],
                        'user_id': adverData[5],
                        }
            photos = []
            
            photoCount = cursor.execute("SELECT * FROM `base_photos` WHERE base_photos.advertise_id = {advertise_id};"
                                        .format(advertise_id =request.data.get('advertise_id')))
            for _ in range(photoCount):
                photoData = cursor.fetchone()
                photos.append(photoData[0])

            mydevertise['photos'] = photos
            return Response(mydevertise, 200)
        else:
            return Response("Advertise not found", 404)

    return Response("Bad Argument", 400)

@api_view(['POST'])
def createAccount(request):
    cursor = connections['default'].cursor()

    if request.data.get('username') is not None and request.data.get('password') is not None:
        cursor.execute("INSERT INTO base_user (username,password) VALUES ('{username}','{password}');".format(username=request.data['username'], password=request.data['password']))
        cursor.execute("INSERT INTO base_normal_user (balance, user_id) VALUES ('{balance}','{user_id}');".format(balance=0, user_id=cursor.lastrowid))
        return Response("Saved Successfully", 200)

    return Response("Bad Argument", 400)


@api_view(['POST'])
def deleteAdvertisement(request):
    cursor = connections['default'].cursor()

    if request.data.get('user_id') is not None and request.data.get('token') is not None and request.data.get('advertise_id') is not None:
        haveToken = cursor.execute("SELECT * FROM base_tokens WHERE user_id = {user_id} AND token = '{token}';".format(user_id=request.data['user_id'], token=request.data['token']))
        if haveToken == 1:
            isDeleted = cursor.execute("DELETE FROM base_advertisement WHERE advertise_id = {ad_id}".format(ad_id = request.data['advertise_id']))
            if isDeleted:
                return Response("Deleted Successfully", 200)
            else:
                return Response("Advertise not Found", 404)
        else:
            return Response("invalid token", 404)
    return Response("Bad Argument", 400)

@api_view(['POST'])
def createOrder(request):
    cursor = connections['default'].cursor()

    if request.data.get('token') is not None and request.data.get('user_id') is not None and request.data.get('advertise_ids') is not None and request.data.get('address') is not None:
        isExist = cursor.execute("SELECT * FROM base_tokens WHERE user_id = {user_id} AND token = '{token}';".format(user_id=request.data['user_id'], token=request.data['token']))
        if isExist == 1 :
            advertisementsIds: list = request.data.get('advertise_ids')
            totalPrice: float = 0
            advertisementsQuantity: dict = {}
            for advertiseId in advertisementsIds:
                advertiseExist = cursor.execute("SELECT price, quantity FROM base_advertisement where advertise_id = {advertise_id}".format(advertise_id=advertiseId))
                if advertiseExist:
                    response = cursor.fetchone()
                    price = response[0]
                    quantity = response[1]
                    advertisementsQuantity[advertiseId] = quantity
                    totalPrice += price
                else:
                    return Response("Advertisement not found", 404)
                
            for advertiseId in advertisementsIds:
                if advertisementsQuantity[advertiseId] == 0:
                    return Response("Quantity is more than available", 404)
                else:
                    advertisementsQuantity[advertiseId] -= 1
            
            isExist = cursor.execute('select balance from base_normal_user where user_id = {user_id};'.format(user_id=request.data.get('user_id')))
            user_balance: float
            if isExist:
                user_balance = cursor.fetchone()[0]
                if user_balance < totalPrice:
                    return Response("Not enough balance", 400)
            
            for advertise_id, quantity in advertisementsQuantity.items():
                cursor.execute('UPDATE base_advertisement set quantity={quantity} where advertise_id = {advertise_id};'.format(advertise_id=advertise_id, quantity=quantity))
            cursor.execute('UPDATE base_normal_user set balance={balance} where user_id = {user_id};'.format(balance=user_balance-totalPrice, user_id= request.data.get('user_id')))
            cursor.execute("INSERT INTO base_order (address, user_id) VALUES ('{address}',{user_id})".format(address=request.data['address'], user_id=request.data['user_id']))
            order_id = cursor.lastrowid
            for advertise_id in request.data.get('advertise_ids'):
                cursor.execute("INSERT INTO base_order_advertises (order_id, advertise_id) VALUES ({order_id},{advertise_id})".format(order_id=order_id, advertise_id=advertise_id))
            return Response("Saved Successfully", 200)
        else :
            return Response("invalid token", 404)
    return Response("Bad Argument", 400)

@api_view(['POST'])
def updateAdvertisement(request):
    cursor = connections['default'].cursor()

    if request.data.get('user_id') is not None and request.data.get('token') is not None and request.data.get('advertise_id') is not None and request.data.get('name') is not None and request.data.get('description') is not None and request.data.get('price') is not None and request.data.get('quantity') is not None and request.data.get('photos') is not None:    
        haveToken = cursor.execute("SELECT * FROM base_tokens WHERE user_id = {user_id} AND token = '{token}';".format(user_id=request.data['user_id'], token=request.data['token']))
        if haveToken == 1:
            updatedCount = cursor.execute("update base_advertisement set price = {price}, name='{name}', quantity={quantity}, description='{description}' WHERE advertise_id={advertise_id}".format(price=request.data['price'], name=request.data['name'], quantity=request.data['quantity'], description=request.data['description'],advertise_id=request.data['advertise_id']))
            if updatedCount:
                cursor.execute("delete from base_photos where advertise_id={adv_id}".format(adv_id=request.data["advertise_id"]))
                for url in request.data["photos"]:
                    cursor.execute("insert into base_photos (url, advertise_id) values('{url}',{adv_id});".format(url=url, adv_id=request.data["advertise_id"]))
                return Response("Updated Successfully", 200)
            else:
                return Response("invalid advertise id", 404)
        else:
            return Response("invalid token", 404)
    return Response("Bad Argument", 400)
    

@api_view(['POST'])
def getAccountDetails(request):
    cursor = connections['default'].cursor()
    if request.data.get('user_id') is not None and request.data.get('token') is not None:
        isExist = cursor.execute("SELECT * FROM base_tokens WHERE user_id = {user_id} AND token = '{token}';".format(user_id = request.data.get("user_id"), token = request.data.get("token")))
        if (isExist == 1):
            cursor = connections['default'].cursor()
            isExist = cursor.execute("SELECT balance, username FROM base_user INNER JOIN base_normal_user ON base_user.user_id = base_normal_user.user_id WHERE base_user.user_id IN(SELECT user_id FROM base_normal_user WHERE user_id = {user_id});".format(user_id = request.data.get("user_id")))
            if(isExist == 1):
                userBalance, userName = cursor.fetchone()
                print(cursor.fetchall())
                responseBody = {"balance": userBalance, "username": userName}
                return Response(responseBody, 200)
        else:
            return Response("Invalid Token" , 400)
    else:

        return Response("Bad Argument", 400)

@api_view(['POST'])
def getPaymentCardsOfSpecificUsers(request):
    cursor = connections['default'].cursor()
    if request.data.get('user_id') is not None and request.data.get('token') is not None:
        isExist = cursor.execute("SELECT * FROM base_tokens WHERE user_id = {user_id} AND token = '{token}';".format(user_id=request.data.get("user_id"), token=request.data.get("token")))
        if (isExist == 1):
            cursor = connections['default'].cursor()
            isExist = cursor.execute("SELECT payment_cards.base_payment_cards.card_no, cvv, month, year FROM payment_cards.base_payment_cards INNER JOIN base_have_payment_cards ON payment_cards.base_payment_cards.card_no = base_have_payment_cards.card_no WHERE user_id IN (SELECT user_id FROM base_have_payment_cards WHERE user_id = {user_id});".format(user_id = request.data.get("user_id")))
            cards = []
            for _ in range(isExist):
                cardNo, cvv, month, year = cursor.fetchone()
                card = {"card_number" : cardNo, "cvv" : cvv, "month" : month, "year" : year}
                cards.append(card)
            print(cursor.fetchall())
            return Response(cards, 200)
        else:
            return Response("Invalid Token", 400)
    else:
        return Response("Bad Argument", 400)

@api_view(['POST'])
def addPaymentCard(request):
    cursor = connections['default'].cursor()
    if request.data.get('user_id') is not None and request.data.get('token') is not None and request.data.get('card_no') is not None and request.data.get('cvv') is not None and request.data.get('month') is not None and request.data.get('year') is not None:
        isExist = cursor.execute("SELECT * FROM base_tokens WHERE user_id = {user_id} AND token = '{token}';".format(user_id=request.data.get("user_id"), token=request.data.get("token")))
        if (isExist == 1):
            cursor = connections['payment_cards'].cursor()
            cursor.execute("INSERT INTO `base_payment_cards` (card_no, cvv, month, year) VALUES ({card_no},{cvv}, {month}, {year});".format(card_no=request.data['card_no'], cvv=request.data['cvv'], month=request.data['month'], year=request.data['year']))
            cursor = connections['default'].cursor()
            cursor.execute("INSERT INTO `base_have_payment_cards` (user_id, card_no) VALUES ({user_id},{card_no});".format(user_id=request.data['user_id'], card_no=request.data['card_no']))
            return Response("Save Successfully!", 200)
        else:
            return Response("Invalid token", 404)
    return Response("Bad argument", 400)


@api_view(['POST'])
def createAdvertisement(request):
    cursor = connections['default'].cursor()

    if request.data.get('name') is not None and request.data.get('description') is not None and request.data.get('price') is not None and request.data.get('quantity') is not None and request.data.get('photos') is not None and request.data.get("user_id") is not None and request.data.get('token') is not None:
        isExist = cursor.execute("SELECT * FROM base_tokens WHERE user_id = {user_id} AND token = '{token}';".format(user_id=request.data.get("user_id"), token=request.data.get("token")))
        if isExist == 1:
            cursor.execute("INSERT INTO base_advertisement (price, name, quantity, description, user_id) VALUES ({price}, '{name}', {quantity}, '{description}', {user_id});".format(price=request.data['price'], description=request.data['description'], quantity=request.data['quantity'], name=request.data['name'], user_id=request.data['user_id']))
            advertise_id = cursor.lastrowid
            cursor2 = connections['default'].cursor()
            for photo in request.data['photos']:
                cursor2.execute("INSERT INTO base_photos (url, advertise_id) VALUES ('{photosUrl}', {advertise_id});".format(photosUrl=photo, advertise_id=advertise_id))

            return Response("Saved Successfully", 200)
        else:
            return Response("Invalid Token", 404)
    else:
        return Response("Bad Argument", 400)

@api_view(['GET'])
def getAllAdvertisementsIds(request):
    cursor = connections['default'].cursor()

    cursor.execute("SELECT advertise_id FROM base_advertisement;")
    ads = cursor.fetchall()

    ad_list = []
    for ad in ads:
        ad_list.append(ad[0])

    return Response(ad_list, 200)

@api_view(['POST'])
def getAllAdvertisementsIdsSorted(request):

    if request.data.get("field") is not None and request.data.get("order") is not None:
        cursor = connections['default'].cursor()

        cursor.execute("SELECT advertise_id FROM base_advertisement ORDER by {field} {order};".format(field=request.data.get("field"), order=request.data.get("order")))
        ads = cursor.fetchall()

        ad_list = []
        for ad in ads:
            ad_list.append(ad[0])

        return Response(ad_list, 200)


@api_view(['Post'])
def addBalanceToUser(request):
    cursor = connections['default'].cursor()
    if request.data.get('user_id') is not None and request.data.get('token') is not None and request.data.get("balance") is not None:    
        haveToken = cursor.execute("SELECT * FROM base_tokens WHERE user_id = {user_id} AND token = '{token}';".format(user_id=request.data['user_id'], token=request.data['token']))
        cursor.execute("SELECT balance from base_normal_user WHERE user_id={user_id}".format(user_id=request.data.get('user_id')))
        currentBalance = cursor.fetchone()[0]
        if haveToken == 1:
            cursor.execute("update base_normal_user set balance = {balance} WHERE user_id={user_id}".format(balance = currentBalance + request.data.get("balance"), user_id = request.data.get('user_id')))
            return Response("Updated Successfully", 200)
        else:
            return Response("invalid token", 404)
    return Response("Bad Argument", 400)

@api_view(['Post'])
def getUserRole(request):
    cursor = connections['default'].cursor()
    if request.data.get('user_id') is not None and request.data.get('token'):    
        haveToken = cursor.execute("SELECT * FROM base_tokens WHERE user_id = {user_id} AND token = '{token}';".format(user_id=request.data['user_id'], token=request.data['token']))
        if haveToken == 1:
            isAdmin = cursor.execute("SELECT * FROM base_admin_user WHERE user_id = {user_id}".format(user_id=request.data.get('user_id')))
            if isAdmin:
                return Response("Admin", 200)
            isVendor = cursor.execute("SELECT * FROM base_vendor_user WHERE user_id = {user_id}".format(user_id=request.data.get('user_id')))
            if isVendor:
                return Response("Vendor", 200)
            return Response("Normal", 200)
        else:
            return Response("invalid token", 404)
    return Response("Bad Argument", 400)

@api_view(['POST'])
def promoteToAdmin(request):
    cursor = connections['default'].cursor()

    if request.data.get('user_id') is not None:    
        cursor.execute("INSERT INTO `base_admin_user` (user_id) VALUES ({u_id});".format(u_id =request.data['user_id']))
        return Response("Promoted Successfully", 200)
    
    return Response("Bad Argument", 400)


@api_view(['POST'])
def promoteToVendor(request):
    cursor = connections['default'].cursor()

    if request.data.get('user_id') is not None:    
        cursor.execute("INSERT INTO `base_vendor_user` (user_id) VALUES ({u_id});".format(u_id =request.data['user_id']))
        return Response("Promoted Successfully", 200)
    
    return Response("Bad Argument", 400)


@api_view(['POST'])
def demotedFromVendor(request):
    cursor = connections['default'].cursor()

    if request.data.get('user_id') is not None:    
        cursor.execute("DELETE FROM `base_vendor_user` WHERE user_id = {u_id};".format(u_id =request.data['user_id']))
        return Response("Demoted Successfully", 200)
    
    return Response("Bad Argument", 400)

@api_view(['POST'])
def demotedFromAdmin(request):
    cursor = connections['default'].cursor()

    if request.data.get('user_id') is not None:    
        cursor.execute("DELETE FROM `base_admin_user` WHERE user_id = {u_id};".format(u_id =request.data['user_id']))
        return Response("Demoted Successfully", 200)
    
    return Response("Bad Argument", 400)


@api_view(['GET'])
def getAllUsersIds(request):
    cursor = connections['default'].cursor()
    cursor.execute("SELECT user_id, username from base_user")
    allUserIds = cursor.fetchall()

    response = []

    for userId in allUserIds:
        isAdmin = cursor.execute("SELECT * FROM base_admin_user WHERE user_id = {user_id}".format(user_id=userId[0]))
        role: str = "normal"
        if isAdmin:
            role = "admin"
        else:
            isVendor = cursor.execute("SELECT * FROM base_vendor_user WHERE user_id = {user_id}".format(user_id=userId[0]))
            if isVendor:
                role = "vendor"
        response.append(
            {
                "user_id": userId[0],
                "username": userId[1],
                "role": role
            }
        )
    
    return Response(response, 400)