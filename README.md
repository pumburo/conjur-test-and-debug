# Conjur test ve debug uygulaması

# Ön Hazırlık

İlk olarak kullanılacak özel imaj build edilmeli ve image registry'ye pushlanmalı
Build edilmiş hali pumburo/library-test-2:1.3 şeklinde dockerhubda mevcuttur. 

# Image Build

image files dizininde "docker build . -t image_name:tag" komutu kullanılarak build alınabilir.

Build alınan image'ın openshift üzerinde kullanabilmesi için image registry'ye pushlanması gerekmektedir.

# Gerekli k8s kaynakları

**serviceaccount**
**role**
**rolebinding**
**configmap**

**oc create sa test-app-sa** komutu ile gerekli serviceaccount create edilebilir.

Role ve RoleBinding için **role_and_rolebinding.yaml** dosyası editlenip apply edilebilir.

Uygulamanın düzgün çalışabilmesi için gereken configmap'i create etmek için gerekli script **create_follower_connection_configmap.sh**'tır ve kurum içerisindeki bilgilere göre editlenmesi gerekmektedir.
**chmod +x create_follower_connection_configmap.sh** komutu ile ilgili script executable hale getirilebilir.
**./create_follower_connection_configmap.sh** komutu ile script çalıştırıldığında cluster'a apply edilecek yaml dosyasını oluşturur.
Oluşan yaml kontrol edildikten sonra eğer doğru ise devam edilir ve gerekli configmap oluşur.
Örnek script **ornek_create_follower_connection_configmap.sh** ismi ile **k8s_resources** dizininde mevcuttur.

# Deployment dosyasında editlenmesi gereken alanlar

containers:
        - name: library-app
          image: 

Yukarıdaki kısımda (21. satır) **image:** yazan alanın sağına image registry üzerindeki ilgili imajın adı ve tag'i girilmelidir.
7. satırdaki **namespace:** kısmı çalışacak namespace olacak şekilde editlenmelidir.

Tüm aşamalar düzgün tamamlandığı takdirde uygulama ayağa kalkacaktır ve  appliace container'ı conjur üzerinden secret çekmeye başlayacaktır.
