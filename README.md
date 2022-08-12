# Conjur test ve debug uygulaması

# Ön Hazırlık

- İlk olarak kullanılacak özel imaj build edilmeli ve image registry'ye pushlanmalı
- Build edilmiş hali pumburo/library-test-2:1.3 şeklinde dockerhubda mevcuttur. 
- Init container için gerekli olan **cyberark/conjur-authn-k8s-client** imageı local registryye pushlanmış olmalıdır

# PS
**Kurulum dosyaları içerisinde yol göstermesi için yorum satırları mevcuttur.**

# Image Build

image files dizininde "docker build . -t image_name:tag" komutu kullanılarak build alınabilir.

Build alınan image'ın openshift üzerinde kullanabilmesi için image registry'ye pushlanması gerekmektedir.

# Gerekli k8s kaynakları

- **serviceaccount**
- **role**
- **rolebinding**
- **configmap**

# Kurulum Adımları

- **oc new-project <application-ns>** komutu ile bir namespace create edilebilir.
- **oc create sa test-app-sa** komutu ile gerekli serviceaccount create edilebilir.
- **role_and_rolebinding.yaml** dosyası yorum satırlarındaki yönergelere göre editlendikten sonra **oc aplly -f role_and_rolebinding.yaml** komutu ile apply edilmeli.
- **give_access_to_follower.yaml** dosyası içerisindeki ilgili alanlar yorum satırlarındaki verilere göre editlendikten sonra **oc apply -f give_access_to_follower.yaml** komutu ile apply edilmeli.
- **create_follower_connection_configmap.sh** dosyası içerisindeki değişkenlere yorum satırlarındaki açıklandığı şekilde değerler girilmelidir. Değerler girildikten sonra **chmod +x create_follower_connection_configmap.sh** komutu ile dosya executable yapılır ve ardından **./create_follower_connection_configmap.sh** komutu ile script çalıştırılır.
**NOT: Scriptin ürettiği çıktı kontrol edilmeli ve doğru ise ekrana **y** yazılıp devam edilmeli. Eğer scriptin ürettiği output hatalı ise script içine yazılmış değişkenler tekrar editlenip script yeniden çalıştırılmalı.**
- **library-method-deployment.yaml** dosyası içerisindeki namespace ve image alanları önceki adımlardaki bilgilere göre editlenmelidir. Edit sonrası **oc apply -f library-method-deployment.yaml** komutu ile deployment apply edilditen sonra ilgili ns altında pod oluşacaktır.
- **oc get po** komutu ile podlar listelenir ve **library-app-XXXX** podu running duruma geçtiğinde **oc logs -f library-app-XXXX** komutu ile loglardan secretlar okunabilir.
**NOT:* Çalışan go kodu ve configmap 2 adet scret çekecek şekilde tasarlanmıştır. Go kodu içerisinde 1 adet secret çekilmek istenirse değişken değersiz kalacağından kod hata verecektir. Tek değişken yada daha fazla değişken çekilmek istendiği takdirde kod düzenlenmelidir.
**NOT:** Bu örnekte init container ile token uygulama containerına aktarılmakta ve ilgili token 8 dakikada expire olmaktadır. Bu sebeplerden ötürü pod runnin konuma geçtikten yaklaşık 8 dakika sonra chrash olacaktır.


